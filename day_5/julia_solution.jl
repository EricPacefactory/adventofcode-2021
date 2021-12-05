
## Load data
use_example = false
input_data = use_example ? "example_input" : "input"
open(input_data) do in_file
    global data_as_strs = readlines(in_file)
end

# Data is 500 lines that look like:
# [
#  "692,826 -> 692,915"
#  "914,338 -> 524,728"
#  "77,505 -> 77,912"
#  ...
# ]

# Get data into matrix of integers
csv_coords = join.(split.(data_as_strs, " -> "), ",")
data_wide = parse.(Int, hcat(split.(csv_coords, ",")...))
data_tall = transpose(data_wide)


## Part 1

# Find maximum co-ord. values, since we'll need this for 'drawing' later
max_x1, max_y1, max_x2, max_y2 = maximum(data_tall, dims = 1)
max_x = max(max_x1, max_x2)
max_y = max(max_y1, max_y2)

# Get size of 'image' that we'll draw, accounting for 0-indexing of data
img_cols = max_x + 1
img_rows = max_y + 1
img_size = (img_rows, img_cols)

function draw_horizontal_segments(image::Matrix, horizontal_segments::Matrix)

    for x1_y1_x2_y2 in eachrow(horizontal_segments)

        # For convenience
        # (adding 1 to deal with Julia indexing at 1 instead of 0)
        x1, y1, x2, y2 = x1_y1_x2_y2 .+ 1
        
        # Safety check
        if y1 != y2
            println("Error! Can't draw non-horizontal line segment:")
            println(x1, " ", y1, " ", x2, " ", y2)
        end
        
        # Make sure we don't have negative ranges before 'drawing'
        sx1, sx2 = sort([x1, x2])
        image[y1, sx1:sx2] .+= 1
    end
    
    return image
end

function draw_vertical_segments(image::Matrix, vertical_segments::Matrix)

    for x1_y1_x2_y2 in eachrow(vertical_segments)

        # For convenience
        # (adding 1 to deal with Julia indexing at 1 instead of 0)
        x1, y1, x2, y2 = x1_y1_x2_y2 .+ 1
        
        # Safety check
        if x1 != x2
            println("Error! Can't draw non-vertical line segment:")
            println(x1, " ", y1, " ", x2, " ", y2)
        end
        
        # Make sure we don't have negative ranges before 'drawing'
        sy1, sy2 = sort([y1, y2])
        image[sy1:sy2, x1] .+= 1
    end
    
    return
end

# Determine which rows are horizontal/vertical
v_seg_idxs = (data_tall[:, 1] .== data_tall[:, 3])
h_seg_idxs = (data_tall[:, 2] .== data_tall[:, 4])

# Grab only the horizontal/vertical segments
v_segs = data_tall[v_seg_idxs, :]
h_segs = data_tall[h_seg_idxs, :]

# Create empty 'image' and draw vert/horizontal segments into it
p1_image = fill(0, img_size)
draw_horizontal_segments(p1_image, h_segs)
draw_vertical_segments(p1_image, v_segs)
answer_p1 = sum(p1_image .> 1)


## Part 2

function draw_diagonal_segments(image::Matrix, diagonal_segments::Matrix)
    
    for x1_y1_x2_y2 in eachrow(diagonal_segments)
    
        # For convenience
        # (adding 1 to deal with Julia indexing at 1 instead of 0)
        x1, y1, x2, y2 = x1_y1_x2_y2 .+ 1
        
        # Safety check
        if x1 == x2 | y1 == y2
            println("Error! Can't draw non-diagonal line segment:")
            println(x1, " ", y1, " ", x2, " ", y2)
        end
        
        # Handle negative indexing
        slice_x = (x2 > x1) ? (x1:x2) : (x1:-1:x2)
        slice_y = (y2 > y1) ? (y1:y2) : (y1:-1:y2)    
        for (px, py) in zip(slice_x, slice_y)
            image[py, px] += 1
        end

    end
    
    return
end

# Find the diagonal segments, assuming they're the 'leftovers'
d_seg_idxs = .!(v_seg_idxs .| h_seg_idxs)
d_segs = data_tall[d_seg_idxs, :]

# Create a new empty 'image' and draw vert/horz/diagonal segments into it
p2_image = fill(0, img_size)
draw_horizontal_segments(p2_image, h_segs)
draw_vertical_segments(p2_image, v_segs)
draw_diagonal_segments(p2_image, d_segs)
answer_p2 = sum(p2_image .> 1)


## Output
println(basename(pwd()))
println("Part 1: ", answer_p1)
println("Part 2: ", answer_p2)
