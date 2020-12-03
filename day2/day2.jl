using DelimitedFiles

function main()
    # parse input
    password_strs = readdlm("input.txt", String)
    display(password_strs)
end

# test day2
main()