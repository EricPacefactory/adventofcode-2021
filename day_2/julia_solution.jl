
## Load data
open("input") do in_file
    global data_as_strs = readlines(in_file)
end
data_str_lines = split.(data_as_strs, " ")

# Clunky feeling way of separating the data
data_as_wide_matrix = hcat(data_str_lines...)
directions = data_as_wide_matrix[1, :]
amounts = parse.(Int64, data_as_wide_matrix[2, :])

# Create vectors holding amounts for each direction so we can vectorize everything
forward_amounts = amounts .* (directions .== "forward")
down_amounts = amounts .* (directions .== "down")
up_amounts = amounts .* (directions .== "up")


## Part 1
horizontal_change = sum(forward_amounts)
depth_change = sum(down_amounts) - sum(up_amounts)
answer_p1 = horizontal_change * depth_change


## Part 2
aim = cumsum(down_amounts - up_amounts)
depth_change = sum(forward_amounts .* aim)
horizontal_change = sum(forward_amounts)
answer_p2 = horizontal_change * depth_change


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
