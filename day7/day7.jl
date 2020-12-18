cd(@__DIR__)


"""
(Directed Acyclic) Graph parsing, generation, traversal, and manipulation. A
special dependency graph (DAG) can be set up with constraints. starting with
the "leaf" nodes and then
mapping them to ... Simple BFS from the required node while checking
constraints will do it.

The entries are found recursively by BFS while keeping track of the constraint
coefficients for each connection (keep multiplying numbers to get #admissible
at any depth; don't count or add if the capacity so far till reaching the
required node is less than needed or if you terminate at the highest node other
than the one that is required).

This problem can also be solved in the "forward" approach ...<> . The
constrained graph in this problem will be represented as follows:
x₁ -> n₁¹y₁¹ + n₂¹y₂¹ + … + nₘ¹yₘ¹, where m is number of non-zero elements
contained in x₁, and so on. The corresponding sub-graph is stored in a ID
referenced hashtable with entry x₁ -> ([yⱼ¹]₁ᵐ, [nⱼ¹]₁ᵐ) and all elements in
the vector [yⱼ¹]₁ᵐ are guaranteed to be keys into the same dictionary with
their own entries, i.e. for every yᵢ¹ ∈ [yⱼ¹]₁ᵐ xₖᵢ === yᵢ¹ for some kᵢ. The
terminating/leaf nodes have an entry of a tuple signifying empty list of
dependees ([""], [0]). BFS in this case will end at leaf nodes or at the
required node.
"""

# define dependent nodes type for graph
const NodeName = AbstractString
const NodeNames = AbstractVector{<:NodeName}
const NodeCoeffs = AbstractVector{<:Integer}
const DepNodes = NamedTuple{(:dependents, :coeffs),Tuple{NodeNames,NodeCoeffs}}
const AbstractGraph = Dict{<:AbstractString,DepNodes}
const Graph = Dict{AbstractString,DepNodes}

# do bfs while propagating capacity constraint on the number of dependee nodes
let dep_nodes = Set{NodeName}()
    function constraint_prop_bfs(graph::AbstractGraph, node::NodeName, constraint::Integer)
        # base case
        if !haskey(graph,node)
            return
        end

        for dep_node ∈ graph[node].dependents
            push!(dep_nodes, dep_node)
            constraint_prop_bfs(graph, dep_node, constraint)
        end
    end

    # returns vector of dependent nodes that satisfy the constraint
    global function get_dependent_nodes(graph::AbstractGraph, node::NodeName,
        constraint::Integer)
        # recurse from dependee to find valid dependents
        constraint_prop_bfs(graph, node, constraint)
        @show dep_nodes
        return dep_nodes
    end
end # let block

# returns number of dependent nodes that satisfy the capacity constraint for dependee
function num_dependent_nodes(graph::AbstractGraph, node::NodeName; constraint::Integer=1)
    return get_dependent_nodes(graph, node, constraint) |> length
end

# returns a graph in the form of a dictionary after parsing all rules
function parse_graph(rules::Vector{<:AbstractString})
    # initialize empty graph
    graph = Graph()

    # function to parse contents by splitting; ready to be parsed as dependees
    parse_contents = rule ->
        findlast("contain ", rule).stop + 1 |>
        (contents_idx -> rule[contents_idx:end]) |>
        (contents -> split(contents, ", "; keepempty=false))

    # function to parse dependees as nodes: ([node names], [node coefficients])
    function parse_dependee_bag(content::AbstractString)
        m = match(r"^(?<coeff>\d+)\s+(?<node>[\w\s]+)(?= bag)", content)

        # leaf node
        if m === nothing
            return ("", 0)
        end

        return (m[:node], parse(Int64, m[:coeff]))
    end

    # function to parse the depender (the bag whose contents are in this rule)
    parse_dependent_bag = rule -> match(r"^[\w\s]+(?= bags contain )", rule).match

    # parse rules and add all nodes with respective entries into the graph:
    # for all dependee nodes/bags, add dependent bag as entry with its coeff
    map(rules) do rule
        dep_node = parse_dependent_bag(rule)

        dependees_info = rule |> parse_contents

        map(dependees_info) do dependee
            node, coeff = parse_dependee_bag(dependee)

            if haskey(graph, node)
                dependents, coeffs = graph[node] # edit subgraph
                push!(dependents, dep_node)
                push!(coeffs, coeff)
            else
                graph[node] = (dependents = [dep_node], coeffs = [coeff]) # insert subgraph
            end
        end
    end

    return graph
end

# run all parts
function main()
    # parse input into
    graph = read("input.txt", String) |> x -> split(x, "\n", keepempty=false) |> parse_graph

    # run
    @show num_dependent_nodes(graph, "shiny gold")
end

# test day 7
main()
