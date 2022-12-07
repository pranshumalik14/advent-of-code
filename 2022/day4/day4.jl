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
    return hcat(listmat...) |> permutedims
end

function solve()
    # parse input
    ranges = parse_rangelists("input.txt")

    # part 1
    overlaps = @. ((first(ranges[:, 2]) <= first(ranges[:, 1])) &
                   (last(ranges[:, 1]) <= last(ranges[:, 2]))) |
                  ((first(ranges[:, 1]) <= first(ranges[:, 2])) &
                   (last(ranges[:, 2]) <= last(ranges[:, 1])))
    @show overlaps |> sum

    # part 2
    ranges = map(ranges) do rangeidx
        return range(rangeidx...)
    end
    partialoverlaps = (ranges[:, 1] .∩ ranges[:, 2]) .|> collect .|> length .|> >(0)
    @show partialoverlaps |> sum
end

# test day 4
solve();
