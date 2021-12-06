
## Load data
open("input") do in_file
    global data_as_strs = readline(in_file)
end
data = parse.(Int, split(data_as_strs, ","))

# Data is list of 300 integers, that looks like:
# [1, 1, 5, 2, 1, 1, 5, ...]


## Part 1

function get_days_left_per_child(start_age, days_left)

    # New child every 7 days after first birth
    first_birth = 1 + start_age
    days_past_iter = 0:7:(days_left - first_birth)

    return [days_left - (first_birth + days_past) for days_past in days_past_iter]
end

function calc_num_descendents(parent_start_age, parent_days_left)
    
    # Get list of days remaining for each of the children
    days_left_per_child = get_days_left_per_child(parent_start_age, parent_days_left)
    
    # Total children for the given parent
    total_children = length(days_left_per_child)
    
    # Now add children-of-children of parent, recursively
    # (assuming each child starts at age 8, as per problem statement)
    for child_days_left in days_left_per_child
        total_children += calc_num_descendents(8, child_days_left)
    end
    
    return total_children
end

num_days = 80

# Count total descendents per parent & sum up all the counts
parent_count = length(data)
descendent_count = sum(calc_num_descendents.(data, num_days))
answer_p1 = parent_count + descendent_count


## Part 2
# Still too slow for larger values...

num_days = 150 # 256

# Calculate the total descendents for every unique parent age
min_data, max_data = extrema(data)
descendent_count_lut = Dict( age => calc_num_descendents(age, num_days) for age = min_data:max_data )

# Replace each parent age in data set with values from lut to save time and sum that up instead
parent_count = length(data)
descendent_count = sum([descendent_count_lut[each_parent] for each_parent in data])
answer_p2 = parent_count + descendent_count


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
