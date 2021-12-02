
with open("input", "r") as in_file:
    data_as_str = in_file.read()
data_str_lines = data_as_str.splitlines()

to_str_int_tuple = lambda direction, amount_str: (direction, int(amount_str))
direction_amount_iter = [to_str_int_tuple(*each_line.split(" ")) for each_line in data_str_lines]

# iter is one thousand 2-tuples that look like:
# [('forward', 2), ('down', 2), ('forward', 6), ('forward', 8), ('down', 8), ...]


#%% Part 1
# - Sum up total amount associated with 'forward' entries as 'horizontal change'
# - Sum total amount of 'down' entries minus the sum of 'up' entries as 'depth change'
# - Report the product of (horizontal * depth) value

horizontal_change = 0
depth_change = 0
for each_direction, each_amount in direction_amount_iter:

    if each_direction == "forward":
        horizontal_change += each_amount

    elif each_direction == "down":
        depth_change += each_amount

    elif each_direction == "up":
        depth_change -= each_amount

    else:
        print("Something went wrong... Got:", each_direction, each_amount)

    pass

answer_p1 = depth_change * horizontal_change


#%% Part 2
# - Track horizontal change same as in part 1
# - Track new 'aim' property, which increases with each 'down' entry and decreases with 'up' entries
# - 'depth change' is now summed on each 'forward' entry as aim * forward-amount
# - Report the product of (horizontal * depth) value

aim = 0
horizontal_change = 0
depth_change = 0
for each_direction, each_amount in direction_amount_iter:

    if each_direction == "forward":
        horizontal_change += each_amount
        depth_change += aim * each_amount

    elif each_direction == "down":
        aim += each_amount

    elif each_direction == "up":
        aim -= each_amount

    else:
        print("Something went wrong... Got:", each_direction, each_amount)

    pass

answer_p2 = depth_change * horizontal_change


#%% Output

print("",
      "Part 1: {}".format(answer_p1),
      "Part 2: {}".format(answer_p2),
      sep = "\n")
