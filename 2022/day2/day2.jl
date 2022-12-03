using DelimitedFiles

cd(@__DIR__)

function parse_rounds(file::String)
    return readdlm(file, ' ', Char, '\n')
end

function compute_score(roundvals::Matrix{Int})
    rounddiff = roundvals[:, 2] - roundvals[:, 1]
    return roundvals[:, 2] + 6(0 .< rounddiff .< 2) + 3(rounddiff .=== 0) + 6(rounddiff .=== -2) |> sum
end

function solve()
    # parse input
    allrounds = parse_rounds("input.txt")

    # part 1
    roundvals = mapslices(allrounds, dims=2) do row
        1 .+ (row - ['A', 'X']) .|> Int
    end
    @show compute_score(roundvals)

    # part 2: re-interpret column 2
    newrounds = mapslices(allrounds, dims=2) do row
        if row[2] === 'X'
            row[2] = row[1] + ('W' - 'A')
            row[2] = (row[2] === 'W') ? 'Z' : row[2] # wrap around
        elseif row[2] === 'Y'
            row[2] = row[1] + ('X' - 'A')
        else
            row[2] = row[1] + ('Y' - 'A')
            row[2] = (row[2] === 'Z' + 1) ? 'X' : row[2] # wrap around
        end
        return row
    end
    roundvals = mapslices(newrounds, dims=2) do row
        1 .+ (row - ['A', 'X']) .|> Int
    end
    @show compute_score(roundvals)
end

# test day 2
solve();
