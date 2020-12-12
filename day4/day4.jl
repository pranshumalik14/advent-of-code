using DelimitedFiles
using Unitful # version 1.0.0 and above

cd(@__DIR__)


"""
Parsing and checking against only required fields in the string according to
the respective criteria; a bunch of efficient string operations and ways to do them.
"""

# shorter names for types
P = String
S = Set{String}

# passport check criteria functions
let 
    check_fields = Set{String}(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"])

    # returns true if passport contains all required fields
    global function check_fields_contained(passport::P, optional_fields::S)
        # initialize fields to be checked
        reqd_fields = setdiff(check_fields, optional_fields)

        return all([contains(passport, field) for field ∈ reqd_fields])
    end

    # returns true if passport contains all required fields with valid values
    global function check_fields_valid(passport::P, optional_fields::S)
        # initialize fields to be checked
        reqd_fields = setdiff(check_fields, optional_fields)

        # parse fields into a {field, value} dict and declare
        field_dict = Dict{String,Any}()
        parse_field_values!(field_dict, passport, reqd_fields)

        # enforce evaluation according to field
        fields_valid = map(collect(reqd_fields)) do field
            if field == "byr"
                check = (v) -> (1920 ≤ v ≤ 2002)
            elseif field == "iyr"
                check = (v) -> (2010 ≤ v ≤ 2020)
            elseif field == "eyr"
                check = (v) -> (2020 ≤ v ≤ 2030)
            elseif field == "hgt"
                check = (v) -> (150u"cm" ≤ v ≤ 76u"inch")
            elseif field == "hcl"
                check = (v) -> (length(v) == 7 && v[1] == '#' && occursin(r"^[a-f0-9]*$", v[2:end]))
            elseif field == "ecl"
                eye_colors = Set{String}(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
                check = (v) -> (v ∈ eye_colors)
            elseif field == "pid"
                check = (v) -> (length(v) == 9)
            elseif field == "cid"
                check = (v) -> (true) # no rule given: true by default
            else
                throw(error("Unhandled field value!"))
            end

            if !haskey(field_dict, field) 
                return false
            else
                println("Checking $field with value $(field_dict[field]): $(check(field_dict[field]))")
                return check(field_dict[field])
            end
        end
        println("Passport is $(all(fields_valid) ? "" : "not") valid!\n####")
        return all(fields_valid)
    end

    # returns a dictionary of {check_fields, value}
    function parse_field_values!(field_dict::Dict{String,Any}, passport::P, required_fields::S)
        # parse values one-by-one according to type expected
        for field ∈ required_fields
            # find field; continue to next if not found
            find = findlast(field, passport)
            if find === nothing 
                continue
            end

            # get the value (match) till '\n' or ' ' after the field string
            val_index = find.stop + 1
            val = match(r"(?<=:)\w*", passport[val_index:end]).match
            
            # parse values as types from string if necessary
            if field == "hgt"
                if !endswith(val, r"in|cm") continue end
                val = uparse(endswith(val, "in") ? val * "ch" : val) # todo: check if unit parsed was of type length
            elseif field ∈ ["byr", "iyr", "eyr"]
                val = parse(Int64, val) # add as int
            end
            
            field_dict[field] = val # add {key = field, value = val}
        end

        return field_dict
    end

end # let block

# returns number of correct passports
function num_valid_passports(passports::Vector{P}, criteria::Function; optional_fields::S=[])
    # result is total correct passports
    return sum([criteria(psprt, optional_fields) for psprt ∈ passports])
end

# run all parts
function main()
    # parse input into array of passport info strings
    psprt_strs = String.(split(read("input.txt", String), "\n\n"))

    # run
    @show num_valid_passports(psprt_strs, check_fields_contained; optional_fields=Set(["cid"]))
    # @show num_valid_passports(psprt_strs) # errored!
    @show num_valid_passports(psprt_strs, check_fields_valid; optional_fields=Set(["cid"]))
end

# test day 4
main()