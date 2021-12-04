
## Load data
open("input") do in_file
    global data_as_strs = readlines(in_file)
end
data_str_lines = split.(data_as_strs, "")

# Get data into matrix format for convenience
data_tall = transpose(parse.(Bool, hcat(data_str_lines...)))
num_rows, num_cols = size(data_tall)
num_1s_per_col = sum(data_tall, dims = 1)
num_0s_per_col = num_rows .- num_1s_per_col

## Part 1

# Get most/least common by comparing totals of 1s and 0s
most_common_per_col = Int.(num_1s_per_col .>= num_0s_per_col)
least_common_per_col = 1 .- most_common_per_col

# May be a more straightforward way to do this...
# Want input like: [1,0,1,1,0] to be interpreted as unsigned integer given in binary
# e.g. [1,0,1,1,0] => binary '10110' => decimal '22' from: (2^4 + 0 + 2^2 + 2^1 + 0)
bit_list_to_int(bit_list) = sum([(b * 2^(k-1)) for (k, b) in enumerate(reverse(bit_list))])

# Calculate final values
gamma_rate = bit_list_to_int(most_common_per_col)
epsilon_rate = bit_list_to_int(least_common_per_col)
answer_p1 = gamma_rate * epsilon_rate


## Part 2

# Set up 'bit critera' checks - mc/lc for most/least common respectively
mc_criteria(data_column) = Int(sum(data_column) .>= (length(data_column) / 2))
lc_criteria(data_column) = Int(sum(data_column) .< (length(data_column) / 2))

# Set up funky filtering described in problem statement (and play with in-place! modifications)
function bit_criteria_filter!(valid_indices, data_column, criteria_fn)

    # We can stop filtering once we have 1 entry
    # (fine for mc filtering and importantly, avoids lc filtering issues)
    only_one_valid_entry = length(valid_indices) == 1
    if only_one_valid_entry
        return
    end

    # Cut down the valid indices based on the given criteria (using logical indexing)
    valid_data = data_column[valid_indices]
    criteria_bit = criteria_fn(valid_data)
    copy!(valid_indices, valid_indices[valid_data .== criteria_bit])
    
    return
end

# Start with list of all row indices and filter them down using 'bit criteria'
valid_mc_idxs = collect(1:num_rows)
valid_lc_idxs = collect(1:num_rows)
for column_data in eachcol(data_tall)
    bit_criteria_filter!(valid_mc_idxs, column_data, mc_criteria)
    bit_criteria_filter!(valid_lc_idxs, column_data, lc_criteria)
end

# Grab target data rows after bit criteria filtering
most_common_bit_list = data_tall[valid_mc_idxs, :]
least_common_bit_list = data_tall[valid_lc_idxs, :]

# Calculate final values
oxygen_generator_rating = bit_list_to_int(most_common_bit_list)
co2_scrubber_rating = bit_list_to_int(least_common_bit_list)
answer_p2 = oxygen_generator_rating * co2_scrubber_rating

## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
