# using THUD
includet("src/THUD.jl")
using .THUD

# Initialize Thud board
board = MakeEmptyBoard(BOARD_SIZE)
StartPositions!(board)

# Print the board
### to repl:
# print_board(board)
### to image
PrintBoard(board)

### ASSUMING PLAYER IS PLAYING DWARVES!!!!!!!!!!!!!!!!!!!!!!!
PLAYER_TURN = true
### count number of turns
number_turns = 0

### number of moves
### dwarves go first, trolls go second


### track moves made
move_tracker = []
### board evaluation tracker
eval_tracker = []

### number of dwarves tracker
num_dwarves_tracker = []
### number of trolls tracker
num_trolls_tracker = []



# board = MoveFromString!(board,"Dw-F1-Mv-F2");


### player playing dwarves

# for i in 1:5

#     ### Dw-G1-Mv-C5

#     println("Enter move string:")
#     move_string = readline()

#     all_strings = CollectAllStrings(board, PLAYER_TURN);

#     @assert move_string ∈ all_strings

#     # @show findfirst(x->x==move_string, all_strings)
    
#     MoveFromString!(board, move_string)

#     UpdateTrackers(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)
#     PrintBoard(board)

#     ### trolls possible moves
#     troll_positions, troll_moves, troll_captures = GetPossibleMoves(board, !PLAYER_TURN)

#     ### randomly select one troll
#     a = rand(1:length(troll_positions))

#     all_strings = []

#     push!(all_strings, [MoveStringFromBoard(troll_positions[a],j,!PLAYER_TURN) for j in troll_moves[a]])
#     push!(all_strings, [CaptureStringFromBoard(troll_positions[a],j,!PLAYER_TURN) for j in troll_captures[a]])

#     possible_troll_moves = reduce(vcat, all_strings)
#     troll_move = rand(possible_troll_moves)

#     MoveFromString!(board, troll_move)

#     UpdateTrackers(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, troll_move, number_turns)
#     PrintBoard(board)

# end