cd(@__DIR__)


"""
(Directed Acyclic) Graph parsing, generation, traversal, and manipulation. The 
constrained graph in this problem will be represented as follows:
x₁ -> n₁¹y₁¹ + n₂¹y₂¹ + … + nₘ¹yₘ¹, where m is number of non-zero elements 
contained in x₁, and so on. The corresponding sub-graph is stored in a ID 
referenced hashtable with entry x₁ -> ([yⱼ¹]₁ᵐ, [nⱼ¹]₁ᵐ) and all elements in 
the vector [yⱼ¹]₁ᵐ are guaranteed to be keys into the same dictionary with 
their own entries, i.e. for every yᵢ¹ ∈ [yⱼ¹]₁ᵐ xₖᵢ === yᵢ¹ for some kᵢ. The 
terminating/leaf nodes have an entry of a tuple of empty arrays ([], []).

The entries are found recursively by <BFS preferably>? while keeping track of 
the constraint coefficients for each depth... (keep multiplying numbers to get 
# admissible at any depth; don't count or add if the capacity so far till 
reaching the required node is less than needed or if you terminate at a node
other than the one that is required).
"""

# run all parts
function main()
    # parse input into 
    read("input.txt", String)
    
    # run
    @show 1
end

# test day 7
main()