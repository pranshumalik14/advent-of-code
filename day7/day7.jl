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
const NodeNames = AbstractVector{<:AbstractString}
const NodeCoeffs = AbstractVector{<:Integer}
const DepNodes = NamedTuple{(:dependents, :coeffs),Tuple{NodeNames,NodeCoeffs}}

# returns vector of dependent nodes <with constraint...>
let a = Vector{AbstractString}()
    global function get_dependent_nodes(graph, node, constraint)
        # recursive function
        return a
    end
end

# returns number of dependent nodes <with constraint...>
function num_dependent_nodes(graph, node; constraint=1)
    return get_dependent_nodes(graph, node, constraint) |> length
end

# returns a graph in the form of a dictionary after parsing all rules
function parse_graph(rules::Vector{<:AbstractString})
    # initialize empty graph
    graph = IdDict{AbstractString,DepNodes}()
    
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

    # parse rules and add all nodes with respective entries into the graph
    map(rules) do rule
        bag = parse_dependent_bag(rule)

        let nodes = Vector{AbstractString}(), coeffs = Vector{Integer}()
            contents = rule |> parse_contents
            
            map(contents) do content
                node, coeff = parse_dependee_bag(content)
                push!(nodes, node) 
                push!(coeffs, coeff)
            end
            
            graph[bag] = (dependents = nodes, coeffs = coeffs) # insert subgraph
        end
    end
    
    return graph
end

# run all parts
function main()
    # parse input into 
    graph = read("input.txt", String) |> blob -> split(blob, "\n") |> parse_graph
    
    # run
    @show length(graph) # get_dependent_nodes(graph, "shiny gold")
end

# test day 7
main()