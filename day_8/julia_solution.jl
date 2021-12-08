
## Load data
open("input") do in_file
    global data_as_strs = readlines(in_file)
end

# Separate data into lists of signal patterns (left side) and outputs (right side)
data_matrix_wide = hcat(split.(data_as_strs, " | ")...)
signal_patterns = split.(data_matrix_wide[1, :], " ")
outputs = split.(data_matrix_wide[2, :], " ")


## Part 1

# Map output data into grid of lengths
output_lengths_matrix = hcat(broadcast.(length, outputs)...)

# Length of signals for digits {1,4,7,8} are [2,4,3,7] respectively
get_num_target_length(target_length) = sum(output_lengths_matrix .== target_length)
answer_p1 = sum(get_num_target_length.([2,4,3,7]))


## Part 2
# ... complicated, may come back to it

answer_p2 = "dnf"


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)