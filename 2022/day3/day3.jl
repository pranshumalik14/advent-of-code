cd(@__DIR__)

function parse_common_items(file::String)
    allitems = readlines(file)
    map(allitems) do rucksack
        halflen = round(Int, length(rucksack) / 2)
        compartments = (SubString(rucksack, 1:halflen),
            SubString(rucksack, halflen+1:length(rucksack))) |> Set
        return intersect(compartments...) |> only
    end
end

function parse_group_badges(file::String)
    badge_groups = Iterators.partition(readlines(file), 3)
    return map(badge_groups) do group
        intersect(Set.(group)...) |> only
    end
end

function getpriorities(items::Vector{Char})
    return map(items) do item
        islowercase(item) ? item - 'a' + 1 : item - 'A' + 27
    end
end

function solve()
    # parse input
    common_items = parse_common_items("input.txt")

    # part 1
    item_priorities = common_items |> getpriorities
    @show item_priorities |> sum

    # part 2
    group_badges = parse_group_badges("input.txt")
    @show group_badges |> getpriorities |> sum
end

# test day 3
solve();
