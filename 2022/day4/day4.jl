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
    numoverlaps = sum(@. first(ranges[:, 2]) <= first(ranges[:, 1]) &&
                         last(ranges[:, 1]) <= last(ranges[:, 2])) +
                  sum(@. first(ranges[:, 1]) <= first(ranges[:, 2]) &&
                         last(ranges[:, 2]) <= last(ranges[:, 1]))
    @show numoverlaps
end

# test day 4
solve();
