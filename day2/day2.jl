using DelimitedFiles

cd(@__DIR__)


"""
// count(i->(i=='f'), "foobar, bar, foo"); length(matchall(Regex(tsub[i]), ts[i]))
"""

function main()
    # parse input
    password_strs = readdlm("input.txt", String)
    @show password_strs
end

# test day2
main()