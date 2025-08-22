### might be worth swapping from plots to Makie for printing the board
### see gist and video below
### can update plots based on where you click -- useful for highlighting possible moves

### https://gist.github.com/Datseris/4b9d25a3ddb3936d3b83d3037f8188dd
### https://www.youtube.com/watch?v=L-gyDvhjzGQ&t=377s


# Function to print board in repl
function print_board(board)
    for i in 1:BOARD_SIZE
        row = board[i, :]
        for j in 1:BOARD_SIZE
            if row[j] == OUTSIDE
                print(" ")
            else
                print(row[j])
            end
            print(" ")
        end
        println()
    end
    println()
end


function SetUpHeatMapGrid(ax)

    x = 1:15
    y = 1:15
    z = zeros(15, 15)

    ### for board colours
    for i in x
        for j in y
            if iseven(i + j)
                z[i, j] = 1.0
            end
        end
    end

    ### remove outside board
    z[1, 1:5] .= NaN
    z[1, 11:15] .= NaN
    z[15, 1:5] .= NaN
    z[15, 11:15] .= NaN
    z[2, 1:4] .= NaN
    z[2, 12:15] .= NaN
    z[14, 1:4] .= NaN
    z[14, 12:15] .= NaN
    z[3, 1:3] .= NaN
    z[3, 13:15] .= NaN
    z[13, 1:3] .= NaN
    z[13, 13:15] .= NaN
    z[4, 1:2] .= NaN
    z[4, 14:15] .= NaN
    z[12, 1:2] .= NaN
    z[12, 14:15] .= NaN
    z[5, 1:1] .= NaN
    z[5, 15:15] .= NaN
    z[11, 1:1] .= NaN
    z[11, 15:15] .= NaN

    hm = heatmap!(ax, x, y, Observable(z), colormap=[:grey, :white])
    ## cbar=false,xticks = (x,files),yticks = (y,ranks)

    return hm
end

function AddLinesToHeatmap!(ax)
    ### lines for edge of board
    lines!(ax, [0.5, 5.5], [5.5, 0.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 0.5], [5.5, 10.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 5.5], [10.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [5.5, 10.5], [15.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [5.5, 10.5], [0.5, 0.5], color=:black, label="", linewidth=1)
    lines!(ax, [10.5, 15.5], [0.5, 5.5], color=:black, label="", linewidth=1)
    lines!(ax, [15.5, 15.5], [5.5, 10.5], color=:black, label="", linewidth=1)
    lines!(ax, [10.5, 15.5], [15.5, 10.5], color=:black, label="", linewidth=1)

    ### vertical lines between squares
    lines!(ax, [1.5, 1.5], [4.5, 11.5], color=:black, label="", linewidth=1)
    lines!(ax, [2.5, 2.5], [3.5, 12.5], color=:black, label="", linewidth=1)
    lines!(ax, [3.5, 3.5], [2.5, 13.5], color=:black, label="", linewidth=1)
    lines!(ax, [4.5, 4.5], [1.5, 14.5], color=:black, label="", linewidth=1)
    lines!(ax, [5.5, 5.5], [0.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [6.5, 6.5], [0.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [7.5, 7.5], [0.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [8.5, 8.5], [0.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [9.5, 9.5], [0.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [10.5, 10.5], [0.5, 15.5], color=:black, label="", linewidth=1)
    lines!(ax, [11.5, 11.5], [1.5, 14.5], color=:black, label="", linewidth=1)
    lines!(ax, [12.5, 12.5], [2.5, 13.5], color=:black, label="", linewidth=1)
    lines!(ax, [13.5, 13.5], [3.5, 12.5], color=:black, label="", linewidth=1)
    lines!(ax, [14.5, 14.5], [4.5, 11.5], color=:black, label="", linewidth=1)

    ### horizontal lines between squares
    lines!(ax, [4.5, 11.5], [1.5, 1.5], color=:black, label="", linewidth=1)
    lines!(ax, [3.5, 12.5], [2.5, 2.5], color=:black, label="", linewidth=1)
    lines!(ax, [2.5, 13.5], [3.5, 3.5], color=:black, label="", linewidth=1)
    lines!(ax, [1.5, 14.5], [4.5, 4.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 15.5], [5.5, 5.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 15.5], [6.5, 6.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 15.5], [7.5, 7.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 15.5], [8.5, 8.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 15.5], [9.5, 9.5], color=:black, label="", linewidth=1)
    lines!(ax, [0.5, 15.5], [10.5, 10.5], color=:black, label="", linewidth=1)
    lines!(ax, [1.5, 14.5], [11.5, 11.5], color=:black, label="", linewidth=1)
    lines!(ax, [2.5, 13.5], [12.5, 12.5], color=:black, label="", linewidth=1)
    lines!(ax, [3.5, 12.5], [13.5, 13.5], color=:black, label="", linewidth=1)
    lines!(ax, [4.5, 11.5], [14.5, 14.5], color=:black, label="", linewidth=1)
end

function AddPiecesToHeatmapGrid!(ax, board, pieces)
    ### add pieces to board
    for column in reverse(1:15)
        row = board[:, column]
        for (idx, r) in enumerate(row)
            if r == 3
                sq = Point(column, idx)
                (marker, color) = pieces[2][1], pieces[2][2]

                push!(piece_scatters[], scatter!(ax, sq; marker, color,
                    strokecolor=color === :white ? :grey : :white,
                    strokewidth=1,
                    markersize=0.8, markerspace=:data
                )
                )

                # annotate!(ax,column,[idx],"R")
            elseif r == 2
                sq = Point(column, idx)
                (marker, color) = pieces[3][1], pieces[3][2]
                push!(piece_scatters[], scatter!(ax, sq; marker, color,
                    strokecolor=color === :white ? :grey : :white,
                    strokewidth=1,
                    markersize=0.8, markerspace=:data
                )
                )

                # annotate!(ax,column,[idx],"T")
            elseif r == 1
                sq = Point(column, idx)
                (marker, color) = pieces[1][1], pieces[1][2]
                push!(piece_scatters[], scatter!(ax, sq; marker, color,
                    strokecolor=color === :white ? :grey : :white,
                    strokewidth=1,
                    markersize=0.8, markerspace=:data
                )
                )

                # annotate!(ax,column,[idx],"D")
            end
        end
    end
end

function ReplacePieces!(ax, piece_scatters, board, pieces)
    ### clear / fix plot by removing and re-placing pieces
    for sc in piece_scatters[]
        delete!(ax, sc)
    end
    empty!(piece_scatters[])
    AddPiecesToHeatmapGrid!(ax, board, pieces)
end

function ShowHighlights!(ax, move_scatters, capture_scatters, moves, captures)

    for move in moves
        push!(move_scatters[], scatter!(ax, move[2], move[1]; marker='o', color=:blue, markersize=0.5, markerspace=:data))
    end
    for capture in captures
        push!(capture_scatters[], scatter!(ax, capture[2], capture[1]; marker='x', color=:red, markersize=0.5, markerspace=:data))
    end

end

function ClearHighlights!(ax, move_scatters, capture_scatters)
    for sc in move_scatters[]
        delete!(ax, sc)
    end
    empty!(move_scatters[])
    for sc in capture_scatters[]
        delete!(ax, sc)
    end
    empty!(capture_scatters[])
end

function ShowTrackers!(ax2, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, number_turns)

    empty!(ax2)

    # t1[] = text!(ax2, 0, 0.5, text = "Turn number : $(number_turns[])", align = (:center, :center))
    # t2[] = text!(ax2, 0, 0.25, text = "Previous move: $(!isempty(move_tracker) ? move_tracker[end] : "---")", align = (:center, :center))
    # t3[] = text!(ax2, 0, 0, text = "Evaluation: $(!isempty(eval_tracker) ? eval_tracker[end] : "---")", align = (:center, :center))
    # t4[] = text!(ax2, 0, -0.25, text = "$(!isempty(num_dwarves_tracker) ? num_dwarves_tracker[end] : "---")", align = (:center, :center))
    # t5[] = text!(ax2, 0, -0.5, text = "$(!isempty(num_trolls_tracker) ? num_trolls_tracker[end] : "---")", align = (:center, :center))

    text!(ax2, 0, 0.5, text = "Turn number : $(number_turns[])", align = (:center, :center))
    text!(ax2, 0, 0.25, text = "Previous move: $(!isempty(move_tracker) ? move_tracker[end] : "---")", align = (:center, :center))
    text!(ax2, 0, 0, text = "Evaluation: $(!isempty(eval_tracker) ? eval_tracker[end] : "---")", align = (:center, :center))
    text!(ax2, 0, -0.25, text = "$(!isempty(num_dwarves_tracker) ? num_dwarves_tracker[end] : "---")", align = (:center, :center))
    text!(ax2, 0, -0.5, text = "$(!isempty(num_trolls_tracker) ? num_trolls_tracker[end] : "---")", align = (:center, :center))

    

end