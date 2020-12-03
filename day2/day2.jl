using DelimitedFiles

cd(@__DIR__)


"""
//
"""

function main()
    # parse input
    password_strs = readdlm("input.txt", String)
    @show password_strs
end

# test day2
main()