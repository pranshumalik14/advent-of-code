using DelimitedFiles

cd(@__DIR__)


"""
Map/2D array traversal on a special repeating map and a specific movement rule.
"""

# returns number of trees encountered while traversing along the slope
function count_trees(map::Vector{String}, down::Int64, right::Int64)
    # initialize count, map size (N × M), and starting position (x, y)
    tree_count = 0
    x = 1
    y = 1
    M = length(map[1])  # columns
    N = length(map)     # rows

    # count trees
    while x ≤ N
        # check
        if map[x][y] == '#'
            tree_count += 1
        end

        # advance
        y = (y - 1 + right) % M + 1
        x = x + down
    end

    return tree_count
end

# run all parts
function main()
    # parse input into a map (array of Strings = 2D array of Char)
    map = readlines("input.txt")
    
    # run
    @show count_trees(map, 1, 3)
    @show count_trees(map, 1, 1) * count_trees(map, 1, 3) * 
        count_trees(map, 1, 5) * count_trees(map, 1, 7) * count_trees(map, 2, 1)
end

# test day 3
main()