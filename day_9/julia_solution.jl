

## Load data
open("input") do in_file
    global data_as_strs = readlines(in_file)
end
data = transpose(parse.(Int, hcat(split.(data_as_strs, "")...)))

# Data is 100x100 matrix of single-digit integers


## Part 1

function check_mins_1d(data_1d)
    
    # Handle boundary checks
    num_entries = length(data_1d)
    first_entry = data_1d[1] < data_1d[2]
    last_entry = data_1d[end] < data_1d[end-1]
    
    # Handle middle (i.e. non-boundary) checks
    data_triplets = zip(data_1d[1:end], data_1d[2:end], data_1d[3:end])
    mid_entries = [(l > c) & (c < r) for (l, c, r) in data_triplets]
    
    return hcat(first_entry, mid_entries..., last_entry)
end

# Check for minima horizontally & vertically and then bitwise AND together to get 2D mins.
horz_pass = transpose(vcat(check_mins_1d.(eachcol(data))...))
vert_pass = vcat(check_mins_1d.(eachrow(data))...)
local_minima_booleans = horz_pass .& vert_pass
local_minima_heights = data[local_minima_booleans]

answer_p1 = sum(local_minima_heights .+ 1)


## Part 2

answer_p2 = "dnf"


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
