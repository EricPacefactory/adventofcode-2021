
input_file_path = "input"
with open("input", "r") as in_file:
    data_as_str = in_file.read()
data = [int(each_line) for each_line in data_as_str.splitlines()]

# Data is a list of two-thousand integers:
# data = [171, 154, 155, 170, 167, 170, 176, ...]


#%% Part 1
# - Count number of times values increase from one list entry to the next

data_pairs_iter = zip(data, data[1:])
num_increases_1 = sum([v2 > v1 for v1, v2 in data_pairs_iter])


#%% Part 2
# - take sum of 3 measurement sliding window of data
# - count number of times the windowed values increase from one entry to the next

data_triplet_iter = zip(data, data[1:], data[2:])
window_sums_iter = [sum(triplet) for triplet in data_triplet_iter]
window_sum_pairs_iter = zip(window_sums_iter, window_sums_iter[1:])
num_increases_2 = sum([v2 > v1 for v1, v2 in window_sum_pairs_iter])


#%% Output

print("",
      "Part 1: {}".format(num_increases_1),
      "Part 2: {}".format(num_increases_2),
      sep = "\n")
