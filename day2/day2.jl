using DelimitedFiles

cd(@__DIR__)


"""
Checking password against different policies/rules. Simple implementation using
generic programming
"""

# struct and outer constructor for storing password with all info
struct Password
    lower_limit::Int64
    upper_limit::Int64
    policy_char::Char
    password::String
end

function Password(pswd_str::T) where T <: Array{<:AbstractString,1}
    # parse info for all  fields
    l_lim_str, u_lim_str = split(pswd_str[1], "-"; limit=2, keepempty=false)
    p_char_str = split(pswd_str[2], ":"; limit=1, keepempty=false)[1]
    l_lim = parse(Int64, l_lim_str)
    u_lim = parse(Int64, u_lim_str)
    p_char = p_char_str[1]::Char
    pswd = String(pswd_str[3])

    # allocate struct
    Password(l_lim, u_lim, p_char_str[1], pswd)
end

# returns true if password abides by policy
function check_pchar_repetition(pswd::Password)::Bool
    # get policy char count in password
    p_char_count = count(i -> (i == pswd.policy_char), pswd.password)

    # check against polict
    if pswd.lower_limit <= p_char_count <= pswd.upper_limit
        return true
    end

    return false
end

function check_pchar_indices(pswd::Password)::Bool
    # get policy char appearance at limit indices in password
    p_char_arr = [pswd.password[pswd.lower_limit], pswd.password[pswd.upper_limit]]
    p_char_count = count(i -> (i == pswd.policy_char), p_char_arr)

    # check against polict
    if p_char_count == 1
        return true
    end

    return false
end

# returns array of correct passwords
function num_correct_pswds(pswds::Array{Password,1}, policy_check::Function)::Int64
    num_correct = 0

    # check for correctness
    for pswd ∈ pswds
        if policy_check(pswd)
            num_correct += 1
        end
    end

    # result
    return num_correct
end

# run all parts
function main()
    # parse input into an array of passwords
    pswd_strs = split.(readlines("input.txt"), " "; limit=3, keepempty=false)
    pswds = Password.(pswd_strs)
    
    # run
    @show num_correct_pswds(pswds, check_pchar_repetition)
    @show num_correct_pswds(pswds, check_pchar_indices)
end

# test day2
main()