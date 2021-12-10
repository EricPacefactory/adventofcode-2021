
## Load data
use_example = false
input_file_name = use_example ? "example" : "input"
open(input_file_name) do in_file
    global data_as_strs = readlines(in_file)
end


## Functions

function find_illegals(row_of_chars)

    # Characters to look for & 'right-to-left' matching lookup table
    l_chars = ['(', '[', '{', '<']
    r_chars = [')', ']', '}', '>']
    match_lut = Dict(r => l for (l, r) in zip(l_chars, r_chars))
    
    # Initialize output
    illegal_char = nothing
    
    # Loop over characters. Assuming first character is 'left', otherwise crash...
    # -> If 'left' add to stack
    # -> If 'right' compare to top of stack
    #   -> If match, pop stack (the 'left' character that was there)
    #   -> If no match, it's illegal
    left_stack = []
    for each_char in row_of_chars
        
        # Debug
        #println(join(left_stack), " ", each_char)
        
        # Add left characters to the stack for future comparisons
        is_left = each_char in l_chars
        if is_left
            push!(left_stack, each_char)
            continue
        end
        
        # 'Right' match last 'left' on stack, otherwise it's illegal
        last_char = left_stack[end]
        is_match = (last_char == match_lut[each_char])
        if last_char != match_lut[each_char]
            illegal_char = each_char
            break
        end
        
        # If we get here, we had a valid left-right match, so remove the left char. from stack
        pop!(left_stack)
    end
    
    return illegal_char
end

function score_p1(char)
    return get(Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137), char, 0)
end

function find_completion_sequence(incomplete_row_of_chars)
    
    # Set up reversal lookup table (only for left-to-right)
    l_chars = ['(', '[', '{', '<']
    r_chars = [')', ']', '}', '>']
    rev_l_to_r_lut = Dict(l => r for (l, r) in zip(l_chars, r_chars))
    reverse_left_to_right(char) = get(rev_l_to_r_lut, char, nothing)

    # Same idea as 'find_illegals', but with no illegals!
    # -> Only care about the end state of the stack after left-right cancellations
    left_stack = [incomplete_row_of_chars[1]]
    for each_char in incomplete_row_of_chars[2:end]
        is_left = each_char in l_chars
        is_left ? push!(left_stack, each_char) : pop!(left_stack)
    end
    
    return reverse_left_to_right.(reverse(left_stack))
    
end

function score_p2(char_sequence)

    score_lut = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
    
    total = 0
    for each_char in char_sequence
        total = 5 * total + score_lut[each_char]
    end
    
    return total
end


#%% Part 1
illegals = find_illegals.(data_as_strs)
answer_p1 = sum(score_p1.(illegals))


## Part 2

# Only score non-illegal sequences
nonillegals = data_as_strs[nothing .== find_illegals.(data_as_strs)]
ordered_scores = sort(score_p2.(find_completion_sequence.(nonillegals)))
answer_p2 = ordered_scores[Int((end+1)/2)]


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)


