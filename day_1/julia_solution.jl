
## Load data
open("input") do in_file
    global data_strs = readlines(in_file)
end
data = parse.(Int64, data_strs)


## Part 1
diffs = data[2:end] - data[1:end-1]
num_increases_p1 = sum(diffs .> 0)


## Part 2
windowed_sums = data[1:end-2] + data[2:end-1] + data[3:end]
wdiffs = windowed_sums[2:end] - windowed_sums[1:end-1]
num_increases_p2 = sum(wdiffs .> 0)

println(basename(pwd()))
println("Part 1:", num_increases_p1)
println("Part 2:", num_increases_p2)
