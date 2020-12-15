cd(@__DIR__)


"""
Set operations: union (∪) and intersect (∩).
"""

# returns number of unique entries in group
@inline function num_unique(group_str::AbstractString)
    # clump groups to one line before adding to set (removes the need for union)
    return group_str |> x -> replace(x, "\n" => "") |> Set |> length
end

# returns number of entries in consensus in a group
@inline function num_consensus(group_str::AbstractString)
    return group_str |> split .|> Set |> x -> reduce(intersect, x) |> length
end

# returns sum of unique entries for all groups
function sum_unique(group_strs::Vector{<:AbstractString})
    return group_strs .|> num_unique |> sum
end

# returns sum of consensus entries for all groups
function sum_consensus(group_strs::Vector{<:AbstractString})
    return group_strs .|> num_consensus |> sum
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