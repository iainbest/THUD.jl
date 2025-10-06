const EMPTY = 0
const DWARF = 1
const TROLL = 2
const KING = 3
const OUTSIDE = 4

const BOARD_SIZE = 15

const files = ["A", "B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "O", "P"]
const ranks = string.([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])

# fast lookup map from file character (Char) to column index
const file_index = Dict{Char,Int}()
for (i, f) in enumerate(files)
	file_index[f[1]] = i
end