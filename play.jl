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
GLMakie.activate!( title = "THUD" )

### initialize some global variables
pieces = [tuple('D', :white), tuple('R', :black), tuple('T',:grey)]
click_mode = Ref(:normal)
selected_square = Ref{Point{2, Int64}}()
dwarf_turn = Ref(true)

### some plotting variables for updating makie plotted board
global move_scatters = Ref(Vector{Any}())
global capture_scatters = Ref(Vector{Any}())
global piece_scatters = Ref(Vector{Any}())

### count number of turns
number_turns = 0

### track moves made
move_tracker = []
### board evaluation tracker
eval_tracker = []

### number of dwarves tracker
num_dwarves_tracker = []
### number of trolls tracker
num_trolls_tracker = []

# Initialize makie figure and axis
f = Figure()
ax = Axis(f[1, 1], aspect = 1)
hidedecorations!(ax)

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
mevents = addmouseevents!(ax.scene, hm)

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

        if [square[2],square[1]] ∈ GetPossibleDwarfMoves(selected_square.x[2],selected_square.x[1],board)

            mvstring = CaptureStringFromBoard([selected_square.x[2], selected_square.x[1]],[square[2], square[1]],"Mv",dwarf_turn[])
            # @show mvstring

            ### perform the dwarf move
            MoveDwarf([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)
            

        elseif [square[2],square[1]] ∈ GetPossibleDwarfHurls(selected_square.x[2],selected_square.x[1],board)

            mvstring = CaptureStringFromBoard([selected_square.x[2], selected_square.x[1]],[square[2], square[1]],"Hu",dwarf_turn[])
            # @show mvstring

            # Perform the capture
            ### check this func call
            HurlDwarf([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)
            
        else
            println("Invalid move or capture selected.")

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
        if [square[2],square[1]] ∈ GetPossibleTrollShoves(selected_square.x[2],selected_square.x[1],board)

            mvstring = CaptureStringFromBoard([selected_square.x[2], selected_square.x[1]],[square[2], square[1]],"Sh",dwarf_turn[])
            # @show mvstring

            ### Perform the capture
            ShoveTroll([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)
            

        elseif [square[2],square[1]] ∈ GetPossibleTrollMoves(selected_square.x[2],selected_square.x[1],board)

            mvstring = CaptureStringFromBoard([selected_square.x[2], selected_square.x[1]],[square[2], square[1]],"Mv",dwarf_turn[])
            # @show mvstring

            ### Perform the move
            MoveTroll([selected_square.x[2], selected_square.x[1]], [square[2], square[1]], board)

            ### clear / fix plot by removing and re-placing pieces
            ReplacePieces!(ax, piece_scatters, board, pieces)

            
        else
            println("Invalid move or capture selected.")

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