using DelimitedFiles
using DataStructures

cd(@__DIR__)

"""
Functions to find a subset of numbers that add up to 2020 (specifically pairs and triplet).
Main idea exploited here is that because we have n unknowns and 1 equation, we will have n - 1 free 
variables that can satisy the equation. The satisfying value of the fixed variable is found in the input
set by matching against the cartesian product of free variables (also input sets). Matching is done through hashtables.
"""

function find_adding_pair(numbers::Array{Int64,2})
    # declare hashtable for fast insert and lookup of numbers
    hashtable = Dict{Int64,Int64}()

    # if number isn't found in hashtable, then insert (2020-number)
    for number ∈ numbers
        if haskey(hashtable, number)
            return number, 2020 - number, number * (2020 - number)
        else
            hashtable[2020 - number] = number
        end
    end

    return "Invalid input. No pairs adding to 2020 found!"
end

function find_adding_triplet(numbers::Array{Int64,2})
    # declare hashtable for lookup
    hashtable = Dict{Int64,Pair{Int64,Int64}}()

    # generate a cartesian product of numbers array
    # and insert missing third number into the hashtable;
    # terminate if we come across a satifying (missing) number
    for x ∈ numbers
        for y ∈ numbers
            if haskey(hashtable, y)
                u, v = hashtable[y]
                return y, u, v, y * u * v
            else
                hashtable[2020 - (x + y)] = Pair{Int64,Int64}(x, y)
            end
        end
    end

    return "Invalid input. No triplets adding to 2020 found!"
end

# run all functions
function main()
    # parse input
    numbers = readdlm("input.txt", Int64)

    # run
    @show find_adding_pair(numbers)
    @show find_adding_triplet(numbers)
end

# test day1
main()