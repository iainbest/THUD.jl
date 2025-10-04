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

    ### get neighbour indices as Vector{SVector{2,Int}}
    neighbours = SVector{2,Int}[(r, c) for (r, c) in allcombinations(row_idxs, column_idxs)]

    ### remove input square as neighbour
    input = SVector{2,Int}(j, i)
    filter!(x -> x != input, neighbours)

    return neighbours
end

function GetDiagonals(j, i, board)
    s = size(board)[1]
    ### declare type of array
    out = SVector{2,Int}[]
    for row in 1:s
        if j == row
            continue
        end
        col1 = i - (j - row)
        if 1 <= col1 <= s
            push!(out, SVector{2,Int}(row, col1))
        end
        col2 = i + (j - row)
        if 1 <= col2 <= s
            push!(out, SVector{2,Int}(row, col2))
        end
    end

    return out
end

### column == file
function GetFile(j, i, board)
    s = size(board)[1]
    ### declare type of array
    out = SVector{2,Int}[]

    for row in 1:s
        if row == j
            continue
        end
    push!(out, SVector{2,Int}(row, i))
    end

    return out
end

### row == rank
function GetRank(j, i, board)
    s = size(board)[1]
    ### declare type of array
    out = SVector{2,Int}[]

    for col in 1:s
        if col == i
            continue
        end
    push!(out, SVector{2,Int}(j, col))
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

    # compute deltas
    dr = to[1] - from[1]
    dc = to[2] - from[2]
    step_r = Int(sign(dr))
    step_c = Int(sign(dc))

    # number of squares including endpoints
    len = max(abs(dr), abs(dc)) + 1
    out = Vector{SVector{2,Int}}(undef, len)

    @inbounds for k in 0:(len-1)
        r = from[1] + k * step_r
        c = from[2] + k * step_c
        out[k+1] = SVector{2,Int}(r, c)
    end

    return out
end

### get squares on other side of [j,i] wrt 'to'
### includes square [j,i]
function GetSquaresOtherSide(from, to, board)
    sq_between = GetSquaresBetween(from, to, board)

    # number of squares to return (including the source square)
    search_length = length(sq_between) - 1
    if search_length <= 0
        return [SVector{2,Int}(from[1], from[2])]
    end

    dr = to[1] - from[1]
    dc = to[2] - from[2]
    # step away from 'to' (opposite direction)
    step_r = -Int(sign(dr))
    step_c = -Int(sign(dc))

    out = Vector{SVector{2,Int}}(undef, search_length)
    @inbounds for k in 0:(search_length-1)
        r = from[1] + k * step_r
        c = from[2] + k * step_c
        out[k+1] = SVector{2,Int}(r, c)
    end

    return out
end

function GetDwarfPositions(board)
    DwarfPositions = SVector{2,Int}[]
    for row in 1:BOARD_SIZE
        for col in 1:BOARD_SIZE
            if board[row, col] == DWARF
                push!(DwarfPositions, SVector{2,Int}(row, col))
            end
        end
    end
    return DwarfPositions
end

function GetTrollPositions(board)
    TrollPositions = SVector{2,Int}[]
    for row in 1:BOARD_SIZE
        for col in 1:BOARD_SIZE
            if board[row, col] == TROLL
                push!(TrollPositions, SVector{2,Int}(row, col))
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