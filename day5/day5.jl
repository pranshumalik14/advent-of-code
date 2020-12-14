cd(@__DIR__)


"""
Data representation, search, and manipulation.
"""

# returns a tuple (row, col) representing the seat from a boarding pass
function get_seat(boardpass::AbstractString)
    # stored in binary representation
    bit_str = boardpass |> x -> map(c -> (c == 'F' || c == 'L') ? '0' : '1', x)
    row_num = parse(Int64, bit_str[1:7]; base=2)
    col_num = parse(Int64, bit_str[8:10]; base=2)
    return (row = row_num, col = col_num)
end

# returns seat ID from seat
function get_seat_id(seat::NamedTuple{(:row, :col)})
    return seat.row * 8 + seat.col
end

# returns highest seat id in the batch
function highest_seat_id(boardpasses::Vector{<:AbstractString})
    return boardpasses .|> get_seat .|> get_seat_id |> maximum
end

# returns the seat id for which id+1 and id-1 both exist in the boarding data
function get_my_seat_id(boardpasses::Vector{<:AbstractString})
    # insert all ids into a dictionary
    seat_ids = Dict{Int64,Tuple{Int64,Int64}}()
    boardpasses .|> get_seat .|> get_seat_id .|> x -> seat_ids[x] = (x + 1, x - 1)

    # iterate through vector while checking if my id is current id or helps find it
    for (id, neighbors) ∈ seat_ids
        if haskey(seat_ids, id + 2) && !haskey(seat_ids, id + 1)
            return  id + 1 # reqd id between neighbor ahead and current id
        elseif haskey(seat_ids, id - 2) && !haskey(seat_ids, id - 1)
            return id - 1 # reqd id between neighbor behind and current id
        end
    end

    throw(error("Your ID was not found among the boarding passes!"))
end

# run all parts
function main()
    # parse input into a vector of strings (boardpasses)
    boardpasses = readlines("input.txt")
    
    # run
    @show highest_seat_id(boardpasses)
    @show get_my_seat_id(boardpasses)
end

# test day 5
main()