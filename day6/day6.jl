cd(@__DIR__)


"""
Set operations: union (∪) and intersect (∩).
"""

# returns number of unique entries in group
@inline function num_unique(group_str::AbstractString)
    return group_str |> Set |> length
end

# returns number of entries in onsensus in a group
@inline function num_consensus(group_str::AbstractString)
    return ∩(group_str |> split .|> Set) |> length
end

# returns sum of unique entries for all groups
function sum_unique(groups_str::Vector{<:AbstractString})
    # clump groups to one line before adding to set
    return groups_str .|> x -> replace(x, "\n" => "") .|> num_unique |> sum
end

# returns sum of consensus entries for all groups
function sum_consensus(groups_str::Vector{<:AbstractString})
    return groups_str .|> num_consensus |> sum
end

# run all parts
function main()
    # parse input into array of group strings
    group_strs = read("input.txt", String) |> x -> split(x, "\n\n")
    
    # run
    @show sum_unique(group_strs)
    @show sum_consensus(group_strs)
end

# test day 6
main()