### get combinations from two or more lists
allcombinations(v...) = vec(collect(Iterators.product(v...)))

### get neighbours of given square on board
### square position is (i,j)
### j is row, i is column in board matrix
function GetSquareNeighbours(j, i)

    row_idxs = [j - 1, j, j + 1]
    column_idxs = [i - 1, i, i + 1]

    ### first remove neighbours above/below top/bottom rows
    if j == 1
        filter!(x -> x != j - 1, row_idxs)
    end
    if j == BOARD_SIZE
        filter!(x -> x != j + 1, row_idxs)
    end

    ### remove neighbours to left/right of first/last columns
    if i == 1
        filter!(x -> x != i - 1, column_idxs)
    end
    if i == BOARD_SIZE
        filter!(x -> x != i + 1, column_idxs)
    end

    ### get neighbour indices as Vector{Vector{Int64}}
    neighbours = collect.(allcombinations(row_idxs, column_idxs))

    ### remove input square as neighbour
    filter!(x -> x != [j, i], neighbours)

    return neighbours
end

function GetDiagonals(j, i, board)
    s = size(board)[1]
    ### declare type of array
    out = Vector{Int64}[]
    for row in 1:s
        if j == row
            continue
        end
        col1 = i - (j - row)
        if 1 <= col1 <= s
            push!(out, [row, col1])
        end
        col2 = i + (j - row)
        if 1 <= col2 <= s
            push!(out, [row, col2])
        end
    end

    return out
end

### column == file
function GetFile(j, i, board)
    s = size(board)[1]
    ### declare type of array
    out = Vector{Int64}[]

    for row in 1:s
        if row == j
            continue
        end
        push!(out, [row, i])
    end

    return out
end

### row == rank
function GetRank(j, i, board)
    s = size(board)[1]
    ### declare type of array
    out = Vector{Int64}[]

    for col in 1:s
        if col == i
            continue
        end
        push!(out, [j, col])
    end

    return out

end

### j is row, i is column in board matrix
function OccupiedSquare(j, i, board)
    # if board[j, i] != EMPTY
    #     return true
    # else
    #     return false
    # end
    board[j, i] != EMPTY ? true : false
end

### get the squares between 'from' and 'to', return them of form [ [from[1],from[2]],[j_1,i_1],[j_2,i_2],...,[to[1],to[2]] ]
function GetSquaresBetween(from, to, board)
    @assert to ∈ GetRank(from..., board) || to ∈ GetFile(from..., board) || to ∈ GetDiagonals(from..., board)

    ### same row
    if from[1] == to[1]
        step = 1
        if to[2] < from[2]
            step = -1
        end
        return [[from[1], k] for k in range(start=from[2], step=step, stop=to[2])]

        ### same column
    elseif from[2] == to[2]
        step = 1
        if to[1] < from[1]
            step = -1
        end
        return [[k, from[2]] for k in range(start=from[1], step=step, stop=to[1])]

        ### diagonal
    else
        r1 = from[1]:to[1]
        r2 = from[2]:to[2]
        if from[1] > to[1]
            r1 = from[1]:-1:to[1]
            # @show collect(r1)
        end
        if from[2] > to[2]
            r2 = from[2]:-1:to[2]
            # @show collect(r2)
        end

        return [[k, l] for (k, l) in zip(r1, r2)]
    end
end

### get squares on other side of [j,i] wrt 'to'
### includes square [j,i]
function GetSquaresOtherSide(from, to, board)

    sq_between = GetSquaresBetween(from, to, board)

    ### need to look this many squares behind [j,i]
    search_length = length(sq_between[1:end-1])

    ### same row
    if from[1] == to[1]

        start = from[2]
        step = 1
        if to[2] > from[2]
            step = -1
        end

        return [[from[1], k] for k in range(start, step=step, length=search_length)]

        ### same column
    elseif from[2] == to[2]

        start = from[1]
        step = 1
        if to[1] > from[1]
            step = -1
        end

        return [[k, from[2]] for k in range(start, step=step, length=search_length)]

        ### diagonal
    else

        step1 = 1
        step2 = 1

        if to[1] > from[1]
            step1 = -1
        end
        if to[2] > from[2]
            step2 = -1
        end

        r1 = range(from[1], step=step1, length=search_length)
        r2 = range(from[2], step=step2, length=search_length)

        return [[k, l] for (k, l) in zip(r1, r2)]
    end
end

function GetDwarfPositions(board)
    DwarfPositions = []
    for row in 1:BOARD_SIZE
        for col in 1:BOARD_SIZE
            if board[row, col] == DWARF
                push!(DwarfPositions, [row, col])
            end
        end
    end
    return DwarfPositions
end

function GetTrollPositions(board)
    TrollPositions = []
    for row in 1:BOARD_SIZE
        for col in 1:BOARD_SIZE
            if board[row, col] == TROLL
                push!(TrollPositions, [row, col])
            end
        end
    end
    return TrollPositions
end

### update trackers of board / game
function UpdateTrackers!(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)
    push!(move_tracker, move_string)
    push!(eval_tracker, EvaluateBoard(board))
    push!(num_dwarves_tracker, CountDwarves(board))
    push!(num_trolls_tracker, CountTrolls(board))
    number_turns[] += 1
end

### undo the last move, i.e. revert board to previous state
function UndoMove!(board, move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, dwarf_turn, use_engine)

    if number_turns[] == 0
        return
    end

    ### clear board to starting positions
    StartPositions!(board)

    ### if using engine, remove last two moves (one player + one engine)
    if use_engine
        splice!(move_tracker, length(move_tracker)-1:length(move_tracker))
        splice!(eval_tracker, length(eval_tracker)-1:length(eval_tracker))
        splice!(num_dwarves_tracker, length(num_dwarves_tracker)-1:length(num_dwarves_tracker))
        splice!(num_trolls_tracker, length(num_trolls_tracker)-1:length(num_trolls_tracker))
        number_turns[] -= 2
    else
        pop!(move_tracker)
        pop!(eval_tracker)
        pop!(num_dwarves_tracker)
        pop!(num_trolls_tracker)
        number_turns[] -= 1
    end

    ### reset board to correct state
    for move in move_tracker

        MoveFromString!(board, move)

    end

    dwarf_turn[] = !dwarf_turn[]

    return

end