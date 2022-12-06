using Chain

cd(@__DIR__)

function parse_rangelists(file::String)
    rangelists = readlines(file)
    listmat = map(rangelists) do ranges
        @chain ranges begin
            split(_, ",")
            split.(_, "-")
            [parse.(Int, x) |> Tuple for x ∈ _]
        end
    end
    return @chain listmat begin
        hcat(_...)
        reshape(_, :, 2)
    end
end

function solve()
    # parse input
    ranges = parse_rangelists("input.txt")

    # part 1
    @show ranges
end

# test day 4
solve();
