using DelimitedFiles

cd(@__DIR__)

function parse_and_sum_cals(file::String)
    allcals = read(file, String)
    map(split(allcals, "\n\n")) do elfcals
        parse.(Int, split(elfcals, '\n')) |> sum
    end
end

function solve()
    # parse input
    elfs_cals = parse_and_sum_cals("input.txt")

    # output max: part 1
    @show elfs_cals |> maximum

    # output sum of max 3: part 2
    @show partialsort!(elfs_cals, 1:3, rev=true) |> sum
end

# test day 1
solve();
