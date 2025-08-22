### might be worth swapping from plots to Makie for printing the board
### see gist and video below

### https://gist.github.com/Datseris/4b9d25a3ddb3936d3b83d3037f8188dd
### https://www.youtube.com/watch?v=L-gyDvhjzGQ&t=377s

### some inspo from:

### https://discourse.julialang.org/t/options-for-simple-board-game-gui/119851/2
### https://juliaplots.org/MakieReferenceImages/gallery/index.html


includet("src/THUD.jl")
using .THUD

### activate glmakie backend to change title of plotting window
GLMakie.activate!(title="THUD")

### initialize some global variables
pieces = [tuple('D', :white), tuple('R', :black), tuple('T', :grey)]
click_mode = Ref(:normal)
selected_square = Ref{Point{2,Int64}}()
dwarf_turn = Ref(true)

### some plotting variables for updating makie plotted board
global move_scatters = Ref(Vector{Any}())
global capture_scatters = Ref(Vector{Any}())
global piece_scatters = Ref(Vector{Any}())

### setup turn counter and trackers
number_turns = Ref(0)
move_tracker = []
eval_tracker = []
num_dwarves_tracker = []
num_trolls_tracker = []

# Initialize makie figure and axis
f = Figure()
ax = Axis(f[1, 1], aspect=1, xticks=(1:15, files), yticks=(1:15, ranks), xgridvisible = false, ygridvisible = false)
ax2 = Axis(f[2, 2], aspect=1, xgridvisible = false, ygridvisible = false)
# hidedecorations!(ax2)
# hidespines!(ax2)

### setup button(s)
f[2, 1] = buttongrid = GridLayout(tellwidth = false, tellheight = false, columns = 2, rows = 1)
buttonlabels = ["Undo Move", "Reset Game"]
buttons = buttongrid[1, 1:2] = [Button(f, label = l) for l in buttonlabels]

f[2, 2] = textgrid = GridLayout(tellwidth = false, tellheight = false, columns = 3, rows = 1)
ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)

# Initialize Thud board
board = MakeEmptyBoard(BOARD_SIZE)
StartPositions!(board)

### set up makie board and add mouse interactivity
hm = SetUpHeatMapGrid(ax)
AddLinesToHeatmap!(ax)
AddPiecesToHeatmapGrid!(ax, board, pieces)
for int in keys(interactions(ax))
    deactivate_interaction!(ax, int)
end
mevents = addmouseevents!(ax.scene)

### setup button behaviour
on(buttons[1].clicks) do b1
    ### undo the move
    UndoMove!(board, move_tracker, dwarf_turn)
    ### clear / fix plot by removing and re-placing pieces
    ClearHighlights!(ax, move_scatters, capture_scatters)
    ReplacePieces!(ax, piece_scatters, board, pieces)

    ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)
end

on(buttons[2].clicks) do b2
    ### reset the game
    StartPositions!(board)
    number_turns[] = 0
    move_tracker = []
    eval_tracker = []
    num_dwarves_tracker = []
    num_trolls_tracker = []
    ClearHighlights!(ax, move_scatters, capture_scatters)
    ReplacePieces!(ax, piece_scatters, board, pieces)
    dwarf_turn[] = true
end


### add mouse behaviour & link to game logic
onmouseleftclick(mevents) do event
    square = round.(Int, event.data)

    ### if dwarf turn and dwarf is selected
    if click_mode[] == :normal && dwarf_turn[] && board[square[2], square[1]] == 1

        ### get possible dwarf moves 
        moves = GetPossibleDwarfMoves(square[2], square[1], board)
        captures = GetPossibleDwarfHurls(square[2], square[1], board)

        ShowHighlights!(ax, move_scatters, capture_scatters, moves, captures)

        click_mode[] = :await_move
        selected_square[] = square

    elseif click_mode[] == :normal && !dwarf_turn[] && board[square[2], square[1]] == 2

        ### get possible troll moves 
        moves = GetPossibleTrollMoves(square[2], square[1], board)
        captures = GetPossibleTrollShoves(square[2], square[1], board)

        ShowHighlights!(ax, move_scatters, capture_scatters, moves, captures)

        click_mode[] = :await_move
        selected_square[] = square

    elseif click_mode[] == :await_move && dwarf_turn[]

        if [square[2], square[1]] ∈ GetPossibleDwarfMoves(selected_square.x[2], selected_square.x[1], board)

            move_string = MoveStringFromBoard([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], dwarf_turn[])

            ### perform the dwarf move
            MoveDwarf([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)

            UpdateTrackers!(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)

            ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)


        elseif [square[2], square[1]] ∈ GetPossibleDwarfHurls(selected_square.x[2], selected_square.x[1], board)

            move_string = CaptureStringFromBoard([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], dwarf_turn[])

            # Perform the capture
            ### check this func call
            HurlDwarf([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)

            UpdateTrackers!(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)

            ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)

        else
            # println("Invalid move or capture selected.")

            ClearHighlights!(ax, move_scatters, capture_scatters)

            ### Reset state
            click_mode[] = :normal
            dwarf_turn[] = dwarf_turn[]

            return

        end

        # Clear highlights
        ClearHighlights!(ax, move_scatters, capture_scatters)

        # Reset state
        click_mode[] = :normal
        # selected_square[] = nothing
        dwarf_turn[] = false

    elseif click_mode[] == :await_move && !dwarf_turn[]

        ### troll capture must go first here! 
        if [square[2], square[1]] ∈ GetPossibleTrollShoves(selected_square.x[2], selected_square.x[1], board)

            move_string = CaptureStringFromBoard([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], dwarf_turn[])

            ### Perform the capture
            ShoveTroll([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)

            UpdateTrackers!(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)

            ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)


        elseif [square[2], square[1]] ∈ GetPossibleTrollMoves(selected_square.x[2], selected_square.x[1], board)

            move_string = MoveStringFromBoard([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], dwarf_turn[])

            ### Perform the move
            MoveTroll([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)

            UpdateTrackers!(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)

            ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)


        else
            # println("Invalid move or capture selected.")

            ClearHighlights!(ax, move_scatters, capture_scatters)

            ### Reset state
            click_mode[] = :normal
            dwarf_turn[] = dwarf_turn[]

            return
        end

        ClearHighlights!(ax, move_scatters, capture_scatters)

        # Reset state
        click_mode[] = :normal
        # selected_square[] = nothing
        dwarf_turn[] = true

    end

    return

end

### display & play
f