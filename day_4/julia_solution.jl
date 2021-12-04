
## Load data
open("input") do in_file
    global data_as_strs = readlines(in_file)
end

# Separate draw numbers and card strings
draw_line_as_str = data_as_strs[1]
card_str_blocks = Iterators.partition(data_as_strs[2:end], 6)


## Parse data into more usable form

# Define bingo card data type for ease of use
struct Bingo_Card
    values::Matrix{Int}
    mask::Matrix{Bool}
end

function parse_one_card(str_block)
    """
    Parses one 'block' of strings into a single bingo card
    Assumes block is given in form:
    [
      "",
      "30 67 16 22 84",
      "81  4 34 61 65",
      "57 69 51 94 58",
      " 6 89 37 75 47",
      "19 14 97  2 86"
    ]
    (i.e. assumes empty string at top, no existing separation of numbers)
    """
    
    # Need a function that converts: " 6 89 37 75 47" -> [6, 89, 37, 75, 47]
    # (without requiring regex wizardry)
    strline_to_intlist(strline) = parse.(Int, join.(Iterators.partition(strline, 3)))
    
    # Convert to a matrix of ints, since that will be easier to work with later
    numbers_int_list = strline_to_intlist.(str_block[2:end])    
    values_matrix = transpose(hcat(numbers_int_list...))
    mask_matrix = fill(false, size(values_matrix))
    
    return Bingo_Card(values_matrix, mask_matrix)    
end

# Parse draw numbers into integers & bingo cards into separate entries
draw_numbers = parse.(Int, split(draw_line_as_str, ","))
all_cards = parse_one_card.(card_str_blocks)


## Part 1

function mark_card(card::Bingo_Card, draw_number)
    
    """
    When a drawn number matches a value on the card,
    flag it in the mask
    """
    
    match_mask = (card.values .== draw_number)
    card.mask[match_mask] .= true
    return
end

function is_winner(card::Bingo_Card)
    
    """
    Card wins when all rows or columns are marked
    Mercifully, diagonals don't count...
    """

    # Check we have a complete row and/or column
    row_win = any(all(card.mask, dims = 1))
    column_win = any(all(card.mask, dims = 2))
    
    return row_win || column_win
end

function part_1_score(card::Bingo_Card, last_drawn_number)
    
    """
    Score for part 1 is the sum of all unmarked values on the card,
    multiplied by the value of the last drawn number
    """
    
    unmarked_sum = sum((1 .- card.mask) .* card.values)
    
    return unmarked_sum * last_drawn_number
end

# Let's play BINGO!
answer_p1 = nothing
for each_draw_number in draw_numbers
    mark_card.(all_cards, each_draw_number)
    card_winners = is_winner.(all_cards)    
    if any(card_winners)
        all_scores = part_1_score.(all_cards, each_draw_number)
        global answer_p1 = all_scores[card_winners][1]
        break
    end
end


## Part 2

# Let's play BINGO! until we're out of cards
answer_p2 = nothing
for each_draw_number in draw_numbers
    mark_card.(all_cards, each_draw_number)
    card_winners = is_winner.(all_cards)    

    # Remove winning cards as long as we have more than 1
    more_than_one_card_remaining = (length(all_cards) > 1)
    if more_than_one_card_remaining
        cards_to_keep = .!card_winners
        global all_cards = all_cards[cards_to_keep]
    else
        # Check if the one remaining card wins
        if any(card_winners)
            global answer_p2 = part_1_score(all_cards[1], each_draw_number)
            break
        end
    end

end


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
