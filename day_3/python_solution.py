
with open("input", "r") as in_file:
    data_as_str = in_file.read()
data_lines = data_as_str.splitlines()

# Convert data to list of integers and get 'transpose' form of data, for convenience
to_int_list = lambda binary_str: [int(each_character) for each_character in binary_str]
data = [to_int_list(each_line) for each_line in data_lines]
data_columns = list(zip(*data))
num_rows = len(data)
num_cols = len(data_columns)

# data is one thousand lists of 1's and 0's, that looks like:
#  [
#   [1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1],
#   [1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1],
#   [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1],
#   ...
#  ]


#%% Part 1
# - Explanation is complex -> see problem statement in readme

# Find most/least common bits by summing along columns to check if more/less than half of rows are 1's
# - Not sure how to handle case where there is equal 1's vs. 0's... but doesn't seem to occur
half_total_rows = num_rows / 2
num_1s_per_column = [sum(each_col) for each_col in data_columns]
most_common_bit_list = [(1 if num_1s > half_total_rows else 0) for num_1s in num_1s_per_column]
least_common_bit_list = [(1 if num_1s < half_total_rows else 0) for num_1s in num_1s_per_column]

# Build up sequence of functions for converting list of bits -> list of strings -> binary string -> decimal number
bit_list_to_str_list = lambda bit_list: [str(each_bit) for each_bit in bit_list]
bit_list_to_binstr = lambda bit_list: "".join(bit_list_to_str_list(bit_list))
bit_list_to_int = lambda bit_list: int(bit_list_to_binstr(bit_list), 2)

# Convert list of bits to decimal number values
gamma_rate = bit_list_to_int(most_common_bit_list)
epsilon_rate = bit_list_to_int(least_common_bit_list)

answer_p1 = gamma_rate * epsilon_rate


#%% Part 2
# - Explanation is even more elaborate than part 1 -> see problem statement in readme

def find_mc_lc_bits(data_rows, target_column_index):

    '''
    Function which figures out the most/least common bits along a target column index for the given data
    - Behaves similar to part 1 solution, but for a single column
    '''

    data_columns = list(zip(*data_rows))
    num_rows = len(data_rows)
    num_1s = sum(data_columns[target_column_index])
    num_0s = num_rows - num_1s

    # 'bit criteria' for most/least common values
    most_common_bit = 1 if num_1s >= num_0s else 0
    least_common_bit = 1 if num_1s < num_0s else 0

    return most_common_bit, least_common_bit

# Start with 2 copies of input data and chop out rows that don't meet 'bit criteria' from problem statement
mc_keepers_list = data.copy()
lc_keepers_list = data.copy()
for col_idx in range(num_cols):

    # Chop down list of entries using most-common criteria
    mc_bit, _ = find_mc_lc_bits(mc_keepers_list, col_idx)
    mc_keepers_list = [each_row for each_row in mc_keepers_list if each_row[col_idx] == mc_bit]

    # Special case: Have to stop at 1 lc entry, otherwise lc-filtering criteria would remove the last entry
    process_least_common = len(lc_keepers_list) > 1
    if process_least_common:
        _, lc_bit = find_mc_lc_bits(lc_keepers_list, col_idx)
        lc_keepers_list = [each_row for each_row in lc_keepers_list if each_row[col_idx] == lc_bit]

# Grab the remaining entries in the keeper lists and convert (list of bits) to a decimal number for interpretation
oxygen_generator_rating = bit_list_to_int(mc_keepers_list[0])
co2_scrubber_rating = bit_list_to_int(lc_keepers_list[0])

answer_p2 = oxygen_generator_rating * co2_scrubber_rating


#%% Output

print("",
      "Part 1: {}".format(answer_p1),
      "Part 2: {}".format(answer_p2),
      sep = "\n")
