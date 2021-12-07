
## Load data
use_example = false
input_file = use_example ? "example" : "input"
open(input_file) do in_file
    global data_as_str = readline(in_file)
end

# Get input data into vector of integers
data = parse.(Int, split(data_as_str, ","))
num_data = length(data)
min_data, max_data = extrema(data)

# Data is list of one thousand integers, that looks like:
# [1101, 1, 29, 67, 1102, 0, ...]


## Part 1

# Construct mesh of all possible positions (duplicated over columns)
all_possible_positions = min_data:max_data
num_possible_positions = length(all_possible_positions)
position_columns_mesh = transpose(repeat(all_possible_positions', num_data))

# Construct mesh of data (duplicated over rows)
data_rows_mesh = repeat(data', outer = num_possible_positions)

# Total cost for each position (row) is sum (along columns) of movement amounts
movement_amounts_mesh = abs.(position_columns_mesh .- data_rows_mesh)
cost_per_position = sum(movement_amounts_mesh, dims = 2)

answer_p1, best_position_index_p1 = findmin(cost_per_position)


## Part 2

# Using counting summation formula (not sure of proper name... probably from Gauss or Euler or something):
#   sum(1, 2, 3, 4, 5,..., n) = n * (n + 1) / 2
# ... kind of cheating, pure code approach would need another few lines I guess
distance_to_cost(distance) = Int(distance * (distance + 1) / 2)

# Map movement amounts from part 1 into new cumulative cost from part 2 before finding totals
cumulative_costs_mesh = distance_to_cost.(movement_amounts_mesh)
cost_per_position = sum(cumulative_costs_mesh, dims = 2)

answer_p2, best_position_index_p2 = findmin(cost_per_position)


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
