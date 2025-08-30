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

    PossibleDwarfMoves = Vector{Vector{Int64}}[]

    ### start with rank
    rank_squares = GetRank(j, i, board)
    ### check for occupied rank_squares
    rank_squares_occupied = [OccupiedSquare(a..., board) for a in rank_squares]

    ### above(right)
    idx = findfirst(x -> x == 1, rank_squares_occupied[findall(x -> x[2] > i, rank_squares)])
    try
        push!(PossibleDwarfMoves, rank_squares[i:findall(x -> x[2] > i, rank_squares)[idx]-1])
    catch e
        ### fix bug where some moves not being found by dwarves
        if idx === nothing && !isempty(findall(x -> x[2] > i, rank_squares))
            push!(PossibleDwarfMoves, rank_squares[i:findall(x -> x[2] > i, rank_squares)[end]])
        else
            push!(PossibleDwarfMoves, [])
        end
        
    end
    ### below(left)
    idx = findlast(x -> x == 1, rank_squares_occupied[findall(x -> x[2] < i, rank_squares)])
    try
        push!(PossibleDwarfMoves, rank_squares[findall(x -> x[2] < i, rank_squares)[idx]+1:i-1])
    catch e
        push!(PossibleDwarfMoves, rank_squares[1:i-1])
    end

    ### then file
    file_squares = GetFile(j, i, board)
    ### check for occupied rank_squares
    file_squares_occupied = [OccupiedSquare(a..., board) for a in file_squares]

    ### above
    idx = findfirst(x -> x == 1, file_squares_occupied[findall(x -> x[1] > j, file_squares)])
    try
        push!(PossibleDwarfMoves, file_squares[j:findall(x -> x[1] > j, file_squares)[idx]-1])
    catch e
        ### fix bug where some moves not being found by dwarves
        if idx === nothing && !isempty(findall(x -> x[1] > j, file_squares))
            push!(PossibleDwarfMoves, file_squares[j:findall(x -> x[1] > j, file_squares)[end]])
        else
            push!(PossibleDwarfMoves, [])
        end
    end
    ### below
    idx = findlast(x -> x == 1, file_squares_occupied[findall(x -> x[1] < j, file_squares)])
    try
        push!(PossibleDwarfMoves, file_squares[findall(x -> x[1] < j, file_squares)[idx]+1:j-1])
    catch e
        push!(PossibleDwarfMoves, file_squares[1:j-1])
    end


    ### then diagonals
    diagonal_squares = GetDiagonals(j, i, board)
    ### check for occupied diagonals
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x -> x == 1, diagonal_squares_occupied)

    ### 4 cases: 
    ### top left
    idx = findall(x -> x[1] < j && x[2] < i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x - [j, i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (decreasing in both j and i until either j or i hits 1)
        while first_occupied_square[1] > 0 || first_occupied_square[2] > 0
            filter!(x -> x != first_occupied_square, diagonal_squares)
            first_occupied_square[1] -= 1
            first_occupied_square[2] -= 1
        end
    catch e
        ### can get ArgumentError: reducing over an empty collection is not allowed; consider supplying `init` to the reducer 
        ### by doing argmin([]) i assume
        ### doesnt seem to break if i catch it here
        ### TODO fix
        # println(e)
    end

    ### top right
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x -> x == 1, diagonal_squares_occupied)

    idx = findall(x -> x[1] < j && x[2] > i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x - [j, i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (decreasing in j and increasing in i until either j hits 1 or i hits 15)
        while first_occupied_square[1] > 0 || first_occupied_square[2] < 16
            filter!(x -> x != first_occupied_square, diagonal_squares)
            first_occupied_square[1] -= 1
            first_occupied_square[2] += 1
        end
    catch e
    end

    ### bottom right
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x -> x == 1, diagonal_squares_occupied)

    idx = findall(x -> x[1] > j && x[2] > i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x - [j, i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (increasing in j and i until either j hits 15)
        while first_occupied_square[1] < 16 || first_occupied_square[2] < 16
            filter!(x -> x != first_occupied_square, diagonal_squares)
            first_occupied_square[1] += 1
            first_occupied_square[2] += 1
        end
    catch e
    end

    ### bottom left
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x -> x == 1, diagonal_squares_occupied)

    idx = findall(x -> x[1] > j && x[2] < i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x - [j, i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (increasing in j and decreasing in i until either j hits 15 or i hits 1)
        while first_occupied_square[1] < 16 || first_occupied_square[2] > 0
            filter!(x -> x != first_occupied_square, diagonal_squares)
            first_occupied_square[1] += 1
            first_occupied_square[2] -= 1
        end
    catch e
    end

    ### push possible moves
    try
        push!(PossibleDwarfMoves, diagonal_squares)
    catch e
        ### if no moves found, push empty vector
        push!(PossibleDwarfMoves, [])
    end

    ### TODO sometimes a MethodError occurs here TODO TODO
    ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    ### not sure what happens - seems to still work...
    ### surpressed in try catch for now

    ### finally reduce to Vector{Int64}
    try
        PossibleDwarfMoves = reduce(vcat, PossibleDwarfMoves)
    catch e
    end

    return PossibleDwarfMoves
end

### j is row, i is column of selected troll in board matrix
function GetPossibleTrollMoves(j, i, board)

    ### start by getting square neighbours
    PossibleTrollMoves = GetSquareNeighbours(j, i)

    ### remove king / rock as possible move
    ### TODO make more general, i.e. remove piece that is labelled KING instead of specific position
    filter!(x -> x != [8, 8], PossibleTrollMoves)

    ### remove possible moves which are OUTSIDE of board
    outside_idx = []
    for (idx, n) in enumerate(PossibleTrollMoves)
        if board[n...] == OUTSIDE
            push!(outside_idx, idx)
        end
    end
    deleteat!(PossibleTrollMoves, outside_idx)

    ### filter out the occupied neighbours
    occupied_idx = []
    for (idx, n) in enumerate(PossibleTrollMoves)
        if board[n...] != EMPTY
            push!(occupied_idx, idx)
        end
    end
    deleteat!(PossibleTrollMoves, occupied_idx)

    return PossibleTrollMoves
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

    ### make huge vector of 'possible' hurls in rank, file, and diagonals - nothing else off limits here!
    PossibleDwarfHurls = Vector{Vector{Int64}}[]
    PossibleDwarfHurls = vcat(PossibleDwarfHurls, GetRank(j, i, board))
    append!(PossibleDwarfHurls, GetFile(j, i, board))
    append!(PossibleDwarfHurls, GetDiagonals(j, i, board))

    # ### TODO sometimes a MethodError occurs here TODO TODO
    # ### not exactly below error, but something like it...
    # ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    # ### not sure what happens - seems to still work...
    # ### surpressed in try catch for now

    # ## reduce to Vector
    # try
    #     PossibleDwarfHurls = reduce(vcat, PossibleDwarfHurls)
    # catch e
    # end

    ### first: dwarf MUST land on troll, all other options are impossible
    more_possible_idx = Int[]
    for (idx, n) in enumerate(PossibleDwarfHurls)
        if board[n...] == TROLL
            push!(more_possible_idx, idx)
        end
    end

    ### if no captures possible, return empty list
    if isempty(more_possible_idx)
        return Vector{Vector{Int64}}[]
    end

    PossibleDwarfHurls = PossibleDwarfHurls[more_possible_idx]

    ### next: get squares between dwarf and target troll
    ### all in between squares MUST be EMPTY
    impossible_idx = Int[]
    for (idx, n) in enumerate(PossibleDwarfHurls)
        path = GetSquaresBetween([j, i], n, board)

        for p in path[2:end-1]
            if board[p...] != EMPTY
                push!(impossible_idx, idx)
                break
            end
        end
    end

    deleteat!(PossibleDwarfHurls, impossible_idx)

    ### if none possible here, no more checks required
    if isempty(PossibleDwarfHurls)
        return PossibleDwarfHurls
    end

    ### finally: dwarf must have enough neighbours in row to hurl across space
    impossible_idx = Int[]
    for (idx, n) in enumerate(PossibleDwarfHurls)
        path = GetSquaresOtherSide([j, i], n, board)

        for p in path
            try
                if board[p...] != DWARF
                    push!(impossible_idx, idx)
                    break
                end
            catch e
                push!(impossible_idx, idx)
                break
            end
        end
    end

    deleteat!(PossibleDwarfHurls, impossible_idx)

    return PossibleDwarfHurls
end

function GetPossibleTrollShoves(j, i, board)

    ### make huge vector of 'possible' shoves in rank, file, and diagonals - nothing else off limits here!
    PossibleTrollShoves = Vector{Vector{Int64}}[]
    PossibleTrollShoves = vcat(PossibleTrollShoves, GetRank(j, i, board))
    append!(PossibleTrollShoves, GetFile(j, i, board))
    append!(PossibleTrollShoves, GetDiagonals(j, i, board))

    # ### TODO sometimes a MethodError occurs here TODO TODO
    # ### not exactly below error, but something like it...
    # ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    # ### not sure what happens - seems to still work...
    # ### surpressed in try catch for now

    # ### reduce to Vector
    # try
    #     PossibleTrollShoves = reduce(vcat, PossibleTrollShoves)
    # catch e
    # end

    ### first: troll MUST land NEXT TO at least one dwarf (and NOT ON a dwarf), all other options are impossible
    more_possible_idx = Int[]
    for (idx, n) in enumerate(PossibleTrollShoves)
        if board[n...] == EMPTY
            neighbours = GetSquareNeighbours(n...)
            for n_ in neighbours
                if board[n_...] == DWARF
                    push!(more_possible_idx, idx)
                    break
                end
            end
        end
    end

    ### if no captures possible, return empty list
    if isempty(more_possible_idx)
        return Vector{Vector{Int64}}[]
    end

    PossibleTrollShoves = PossibleTrollShoves[more_possible_idx]

    ### next: get squares between troll and target dwarf
    ### all in between squares MUST be EMPTY
    impossible_idx = Int[]
    for (idx, n) in enumerate(PossibleTrollShoves)
        path = GetSquaresBetween([j, i], n, board)

        for p in path[2:end-1]
            if board[p...] != EMPTY
                push!(impossible_idx, idx)
                break
            end
        end
    end

    deleteat!(PossibleTrollShoves, impossible_idx)

    ### if none possible here, no more checks required
    if isempty(PossibleTrollShoves)
        return PossibleTrollShoves
    end

    ### finally: troll must have enough neighbours in row to shove across space
    impossible_idx = Int[]
    for (idx, n) in enumerate(PossibleTrollShoves)
        path = GetSquaresOtherSide([j, i], n, board)

        for p in path
            try
                if board[p...] != TROLL
                    push!(impossible_idx, idx)
                    break
                end
            catch e
                push!(impossible_idx, idx)
                break
            end
        end
    end

    deleteat!(PossibleTrollShoves, impossible_idx)

    return PossibleTrollShoves

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