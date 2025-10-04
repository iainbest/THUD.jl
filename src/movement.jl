using StaticArrays

### place board functions here too since all movement/logic etc takes place on board
### make (empty!) board
function MakeEmptyBoard(BOARD_SIZE)
    return fill(EMPTY, (BOARD_SIZE, BOARD_SIZE))
end

# Set the starting positions of the pieces
function StartPositions!(board)

    ### set entire board to empty
    board .= EMPTY

    ### set outside of board
    board[1, 1:5] .= OUTSIDE
    board[1, 11:15] .= OUTSIDE
    board[15, 1:5] .= OUTSIDE
    board[15, 11:15] .= OUTSIDE
    board[2, 1:4] .= OUTSIDE
    board[2, 12:15] .= OUTSIDE
    board[14, 1:4] .= OUTSIDE
    board[14, 12:15] .= OUTSIDE
    board[3, 1:3] .= OUTSIDE
    board[3, 13:15] .= OUTSIDE
    board[13, 1:3] .= OUTSIDE
    board[13, 13:15] .= OUTSIDE
    board[4, 1:2] .= OUTSIDE
    board[4, 14:15] .= OUTSIDE
    board[12, 1:2] .= OUTSIDE
    board[12, 14:15] .= OUTSIDE
    board[5, 1:1] .= OUTSIDE
    board[5, 15:15] .= OUTSIDE
    board[11, 1:1] .= OUTSIDE
    board[11, 15:15] .= OUTSIDE

    ### set king
    board[8, 8] = KING

    ### set trolls
    board[7, 7] = TROLL
    board[7, 8] = TROLL
    board[7, 9] = TROLL
    board[8, 7] = TROLL
    board[8, 9] = TROLL
    board[9, 7] = TROLL
    board[9, 8] = TROLL
    board[9, 9] = TROLL

    ### set dwarves
    board[1, 6] = DWARF
    board[1, 7] = DWARF
    board[1, 9] = DWARF
    board[1, 10] = DWARF
    board[2, 5] = DWARF
    board[2, 11] = DWARF
    board[3, 4] = DWARF
    board[3, 12] = DWARF
    board[4, 3] = DWARF
    board[4, 13] = DWARF
    board[5, 2] = DWARF
    board[5, 14] = DWARF
    board[6, 1] = DWARF
    board[6, end] = DWARF
    board[7, 1] = DWARF
    board[7, end] = DWARF
    board[9, 1] = DWARF
    board[9, end] = DWARF
    board[10, 1] = DWARF
    board[10, end] = DWARF
    board[11, 2] = DWARF
    board[11, 14] = DWARF
    board[12, 3] = DWARF
    board[12, 13] = DWARF
    board[13, 4] = DWARF
    board[13, 12] = DWARF
    board[14, 5] = DWARF
    board[14, 11] = DWARF
    board[end, 6] = DWARF
    board[end, 7] = DWARF
    board[end, 9] = DWARF
    board[end, 10] = DWARF
end

function TestHurlBoard!(board)

    ### set entire board to empty
    board .= EMPTY

    ### set outside of board
    board[1, 1:5] .= OUTSIDE
    board[1, 11:15] .= OUTSIDE
    board[15, 1:5] .= OUTSIDE
    board[15, 11:15] .= OUTSIDE
    board[2, 1:4] .= OUTSIDE
    board[2, 12:15] .= OUTSIDE
    board[14, 1:4] .= OUTSIDE
    board[14, 12:15] .= OUTSIDE
    board[3, 1:3] .= OUTSIDE
    board[3, 13:15] .= OUTSIDE
    board[13, 1:3] .= OUTSIDE
    board[13, 13:15] .= OUTSIDE
    board[4, 1:2] .= OUTSIDE
    board[4, 14:15] .= OUTSIDE
    board[12, 1:2] .= OUTSIDE
    board[12, 14:15] .= OUTSIDE
    board[5, 1:1] .= OUTSIDE
    board[5, 15:15] .= OUTSIDE
    board[11, 1:1] .= OUTSIDE
    board[11, 15:15] .= OUTSIDE

    ### set king
    board[8, 8] = KING

    ### set trolls
    board[7, 7] = TROLL

    ### set dwarves
    board[8, 6] = DWARF
    board[4, 4] = DWARF
    board[5, 9] = DWARF
    board[4, 10] = DWARF
    board[7, 11] = DWARF
    board[7, 12] = DWARF
    board[7, 13] = DWARF
    board[7, 14] = DWARF
    board[9, 9] = DWARF
    board[10, 7] = DWARF
    board[11, 7] = DWARF
    board[12, 7] = DWARF
    board[13, 7] = DWARF

end

function TestShoveBoard!(board)

    ### set entire board to empty
    board .= EMPTY

    ### set outside of board
    board[1, 1:5] .= OUTSIDE
    board[1, 11:15] .= OUTSIDE
    board[15, 1:5] .= OUTSIDE
    board[15, 11:15] .= OUTSIDE
    board[2, 1:4] .= OUTSIDE
    board[2, 12:15] .= OUTSIDE
    board[14, 1:4] .= OUTSIDE
    board[14, 12:15] .= OUTSIDE
    board[3, 1:3] .= OUTSIDE
    board[3, 13:15] .= OUTSIDE
    board[13, 1:3] .= OUTSIDE
    board[13, 13:15] .= OUTSIDE
    board[4, 1:2] .= OUTSIDE
    board[4, 14:15] .= OUTSIDE
    board[12, 1:2] .= OUTSIDE
    board[12, 14:15] .= OUTSIDE
    board[5, 1:1] .= OUTSIDE
    board[5, 15:15] .= OUTSIDE
    board[11, 1:1] .= OUTSIDE
    board[11, 15:15] .= OUTSIDE

    ### set king
    board[8, 8] = KING

    ### set trolls
    board[7, 7] = TROLL
    board[7, 8] = TROLL
    board[7, 9] = TROLL
    board[8, 7] = TROLL
    board[9, 7] = TROLL
    board[10, 7] = TROLL
    board[8, 6] = TROLL
    board[9, 5] = TROLL

    ### set dwarves
    board[1, 6] = DWARF
    board[1, 7] = DWARF
    board[2, 5] = DWARF
    board[3, 4] = DWARF
    board[5, 2] = DWARF
    board[6, 2] = DWARF
    board[7, 2] = DWARF
    board[6, 1] = DWARF
    board[7, 1] = DWARF
    board[4, 11] = DWARF
    board[12, 3] = DWARF
    board[13, 4] = DWARF
    board[14, 6] = DWARF
    board[14, 8] = DWARF
    board[6, 13] = DWARF
    board[7, 13] = DWARF
    board[8, 13] = DWARF

end

### j is row, i is column of selected dwarf in board matrix
function GetPossibleDwarfMoves(j, i, board)
    # Walk in each of the 8 directions and collect empty squares until blocked
    results = SVector{2,Int}[]
    directions = ((-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1))
    nrows, ncols = size(board)

    @inbounds for (dr, dc) in directions
        r = j + dr
        c = i + dc
        while 1 <= r <= nrows && 1 <= c <= ncols
            v = board[r, c]
            # stop if outside or king
            if v == OUTSIDE || v == KING
                break
            end
            # if empty, it's a legal move; if occupied, can't move further
            if v == EMPTY
                push!(results, SVector{2,Int}(r, c))
                r += dr
                c += dc
                continue
            else
                break
            end
        end
    end

    return results
end

### j is row, i is column of selected troll in board matrix
function GetPossibleTrollMoves(j, i, board)
    # Trolls can move to any adjacent empty square (excluding OUTSIDE/KING)
    out = SVector{2,Int}[]
    for nb in GetSquareNeighbours(j, i)
        v = board[nb[1], nb[2]]
        if v == EMPTY
            push!(out, nb)
        end
    end
    return out
end

### dwarves move like a chess queen
### from and to are of form [j, i]
function MoveDwarf!(from, to, board)
    @assert board[from...] == DWARF
    @assert to ∈ GetPossibleDwarfMoves(from[1], from[2], board)

    board[from[1], from[2]] = EMPTY
    board[to[1], to[2]] = DWARF
    return board
end

### trolls move like a chess king
### from and to are of form [j, i]
function MoveTroll!(from, to, board)
    @assert board[from...] == TROLL
    @assert to ∈ GetPossibleTrollMoves(from[1], from[2], board)

    board[from[1], from[2]] = EMPTY
    board[to[1], to[2]] = TROLL
    
    ### after movement, troll has captures surrounding dwarves (should they always?)
    ### currently choosing to always capture
    neighbours = GetSquareNeighbours(to[1], to[2])
    for n in neighbours
        if board[n...] == DWARF
            board[n...] = EMPTY
        end
    end

    return board
end

### j is row, i is column of selected dwarf in board matrix
function GetPossibleDwarfHurls(j, i, board)

    # gather candidate targets along rank, file and diagonals
    candidates = SVector{2,Int}[]
    append!(candidates, GetRank(j, i, board))
    append!(candidates, GetFile(j, i, board))
    append!(candidates, GetDiagonals(j, i, board))

    # quick reject: only targets that are trolls matter
    candidates = [c for c in candidates if board[c...] == TROLL]
    if isempty(candidates)
        return SVector{2,Int}[]
    end

    nrows, ncols = size(board)
    inbounds = (p::SVector{2,Int}) -> 1 <= p[1] <= nrows && 1 <= p[2] <= ncols

    results = SVector{2,Int}[]

    # for each troll target, check path emptiness and dwarf line on the other side
    src = SVector{2,Int}(j, i)
    for target in candidates
        # path between source and target: interior squares must be EMPTY
        path = GetSquaresBetween(src, target, board)
        ok = true
        for p in path[2:end-1]
            if board[p...] != EMPTY
                ok = false
                break
            end
        end
        if !ok
            continue
        end

        # squares on the other side (must all be DWARF)
        other_side = GetSquaresOtherSide(src, target, board)
        ok = true
        for p in other_side
            # skip invalid/outside coordinates quickly
            if !inbounds(p) || board[p...] != DWARF
                ok = false
                break
            end
        end
        if ok
            push!(results, target)
        end
    end

    return results
end

function GetPossibleTrollShoves(j, i, board)
    # gather candidate targets along rank, file and diagonals
    candidates = SVector{2,Int}[]
    append!(candidates, GetRank(j, i, board))
    append!(candidates, GetFile(j, i, board))
    append!(candidates, GetDiagonals(j, i, board))

    # quick reject: landing square must be EMPTY and adjacent to at least one DWARF
    filtered = SVector{2,Int}[]
    for c in candidates
        if board[c...] == EMPTY
            for nb in GetSquareNeighbours(c...)
                if board[nb...] == DWARF
                    push!(filtered, c)
                    break
                end
            end
        end
    end
    if isempty(filtered)
        return SVector{2,Int}[]
    end

    nrows, ncols = size(board)
    inbounds = (p::SVector{2,Int}) -> 1 <= p[1] <= nrows && 1 <= p[2] <= ncols

    results = SVector{2,Int}[]
    for target in filtered
        # path between source and target: interior squares must be EMPTY
        path = GetSquaresBetween(SVector{2,Int}(j, i), target, board)
        ok = true
        for p in path[2:end-1]
            if board[p...] != EMPTY
                ok = false
                break
            end
        end
        if !ok
            continue
        end

        # squares on the other side (must all be TROLL)
        other_side = GetSquaresOtherSide(SVector{2,Int}(j, i), target, board)
        ok = true
        for p in other_side
            if !inbounds(p) || board[p...] != TROLL
                ok = false
                break
            end
        end
        if ok
            push!(results, target)
        end
    end

    return results

end

### dwarf capture move
### straight line of dwarves, hurl dwarf less than or equal to number of dwarves in line
### dwarf at front of line replaces position of targeted troll (which is captured)
### from and to are of form [j, i]
function HurlDwarf!(from, to, board)
    @assert board[from...] == DWARF
    @assert to ∈ GetPossibleDwarfHurls(from[1], from[2], board)

    board[from[1], from[2]] = EMPTY
    board[to[1], to[2]] = DWARF
    return board

end

### troll (special) capture move - as trolls also capture after normal movement
### straight line of trolls, shove troll less than or equal to number of trolls in line
### troll aims to land next to dwarves to capture
### troll MUST capture at least one dwarf if making this move
### i believe that with this move, all possible dwarves are captured
### from and to are of form [j, i]
function ShoveTroll!(from, to, board)
    @assert board[from...] == TROLL
    @assert to ∈ GetPossibleTrollShoves(from[1], from[2], board)

    board[from[1], from[2]] = EMPTY
    board[to[1], to[2]] = TROLL

    neighbours = GetSquareNeighbours(to[1], to[2])
    for n in neighbours
        if board[n...] == DWARF
            board[n...] = EMPTY
        end
    end

    return board

end

### returns three lists: current positions, candidate move positions (per each position in current positions) and candidate capture positions (similarly)
function GetAllPossibleMoves(board, dwarf_turn)

    if dwarf_turn[]
        ### dwarves move
        @assert CountDwarves(board) > 0

        ### TODO type declarations
        Moves = Vector{Vector{Int64}}[]
        Hurls = Vector{Vector{Int64}}[]

        ### get where dwarves are
        DwarfPositions = GetDwarfPositions(board)

        ### for each, get possible moves
        for pos in DwarfPositions
            push!(Moves, GetPossibleDwarfMoves(pos[1], pos[2], board))
        end
        ### ...and hurls
        for pos in DwarfPositions
            push!(Hurls, GetPossibleDwarfHurls(pos[1], pos[2], board))
        end

        return DwarfPositions, Moves, Hurls

    else
        ### trolls move
        @assert CountTrolls(board) > 0

        ### TODO type declarations
        Moves = Vector{Vector{Int64}}[]
        Shoves = Vector{Vector{Int64}}[]

        ### get where trolls are
        TrollPositions = GetTrollPositions(board)

        ### for each, get possible moves
        for pos in TrollPositions
            push!(Moves, GetPossibleTrollMoves(pos[1], pos[2], board))
        end
        ### ...and shoves
        for pos in TrollPositions
            push!(Shoves, GetPossibleTrollShoves(pos[1], pos[2], board))
        end

        return TrollPositions, Moves, Shoves
    end

end