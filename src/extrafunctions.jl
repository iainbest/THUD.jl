function GetBoardSize(board)
    @assert size(board)[1] == size(board)[2]
    return size(board)[1]
end

function GetTurn(board)
    ### TODO
end


### check that board corners are empty
function CheckBoardCorners
    ### TODO
end

### get combinations from two or more lists
allcombinations(v...) = vec(collect(Iterators.product(v...)))

### get neighbours of given square on board
### square position is (i,j)
### j is row, i is column in board matrix
function GetSquareNeighbours(j, i, board)

    row_idxs = [j-1, j, j+1]
    column_idxs = [i-1, i, i+1]

    ### first remove neighbours above/below top/bottom rows
    if j == 1
        filter!(x->x!=j-1, row_idxs)
    end
    if j == 15
        filter!(x->x!=j+1, row_idxs)
    end

    ### remove neighbours to left/right of first/last columns
    if i == 1
        filter!(x->x!=i-1, column_idxs)
    end
    if i == 15
        filter!(x->x!=i+1, column_idxs)
    end

    ### get neighbour indices as Vector{Vector{Int64}}
    neighbours = collect.(allcombinations(row_idxs, column_idxs))

    ### remove input square as neighbour
    filter!(x->x!=[j,i],neighbours)

    # ### remove king / rock as possible neighbour
    # filter!(x->x!=[8,8],neighbours)

    # ### remove neighbours which are OUTSIDE of board
    # outside_idx = []
    # for (idx,n) in enumerate(neighbours)
    #     if board[n...] == OUTSIDE
    #         push!(outside_idx,idx)
    #     end
    # end
    # deleteat!(neighbours,outside_idx)

    return neighbours
end

function GetDiagonals(j, i, board)
    s = size(board)[1]
    out = []
    for row in 1:s
        if j == row
            continue
        end
        col1 = i - (j-row)
        if 1 <= col1 <= s
            push!(out, [row,col1])
        end
        col2 = i + (j-row)
        if 1 <= col2 <= s
            push!(out, [row,col2])
        end
    end

    # ### trim the values OUTSIDE the board
    # outside_idx = []
    # for (idx,n) in enumerate(out)
    #     if board[n...] == OUTSIDE
    #         push!(outside_idx,idx)
    #     end
    # end
    # deleteat!(out,outside_idx)

    # ### remove king / rock as possible
    # filter!(x->x!=[8,8],out)

    # ### thinking ahead, we probably want to sort this by distance from starting square, so
    # dists = [norm(x-[j,i]) for x in out]
    # p = sortperm(dists)
    # ### out (list of diagonal indices from start square (j,i)) now ordered by distance
    # out = out[p]

    return out
end

### column == file
function GetFile(j, i, board)
    s = size(board)[1]
    out = []

    for row in 1:s
        if row == j
            continue
        end
        push!(out, [row, i])
    end

    # ### thinking ahead, we probably want to sort this by distance from starting square, so
    # dists = [norm(x-[j,i]) for x in out]
    # p = sortperm(dists)
    # ### out (list of file indices from start square (j,i)) now ordered by distance
    # out = out[p]

    return out
end

### row == rank
function GetRank(j, i, board)
    s = size(board)[1]
    out = []

    for col in 1:s
        if col == i
            continue
        end
        push!(out, [j, col])
    end

    # ### thinking ahead, we probably want to sort this by distance from starting square, so
    # dists = [norm(x-[j,i]) for x in out]
    # p = sortperm(dists)
    # ### out (list of rank indices from start square (j,i)) now ordered by distance
    # out = out[p]

    return out

end

### j is row, i is column in board matrix
function OccupiedSquare(j, i, board)
    if board[j, i] != EMPTY
        return true
    else
        return false
    end
end

function OutsideSquare(j, i, board)
    if board[j, i] == OUTSIDE
        return true
    else
        return false
    end
end

### j is row, i is column of selected dwarf in board matrix
function GetPossibleDwarfMoves(j, i, board)

    PossibleDwarfMoves = Vector{Vector{Int64}}[]

    ### start with rank
    rank_squares = GetRank(j, i, board)
    ### check for occupied rank_squares
    rank_squares_occupied = [OccupiedSquare(a..., board) for a in rank_squares]

    ### above(right)
    idx = findfirst(x->x==1,rank_squares_occupied[findall(x->x[2]>i, rank_squares)])
    try
        push!(PossibleDwarfMoves,rank_squares[i:findall(x->x[2]>i, rank_squares)[idx]-1])
    catch e
        push!(PossibleDwarfMoves,[])
    end
    ### below(left)
    idx = findlast(x->x==1,rank_squares_occupied[findall(x->x[2]<i, rank_squares)])
    try
        push!(PossibleDwarfMoves,rank_squares[findall(x->x[2]<i, rank_squares)[idx]+1:i-1])
    catch e
        push!(PossibleDwarfMoves,rank_squares[1:i-1])
    end

    ### then file
    file_squares = GetFile(j, i, board)
    ### check for occupied rank_squares
    file_squares_occupied = [OccupiedSquare(a..., board) for a in file_squares]

    ### above
    idx = findfirst(x->x==1,file_squares_occupied[findall(x->x[1]>j, file_squares)])
    try
        push!(PossibleDwarfMoves,file_squares[j:findall(x->x[1]>j, file_squares)[idx]-1])
    catch e
        push!(PossibleDwarfMoves,[])
    end
    ### below
    idx = findlast(x->x==1,file_squares_occupied[findall(x->x[1]<j, file_squares)])
    try
        push!(PossibleDwarfMoves,file_squares[findall(x->x[1]<j, file_squares)[idx]+1:j-1])
    catch e
        push!(PossibleDwarfMoves,file_squares[1:j-1])
    end


    ### then diagonals
    diagonal_squares = GetDiagonals(j, i, board)
    ### check for occupied diagonals
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x->x==1, diagonal_squares_occupied)

    ### 4 cases: 
    ### top left
    idx = findall(x->x[1]<j && x[2]<i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x-[j,i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (decreasing in both j and i until either j or i hits 1)
        while first_occupied_square[1] > 0 || first_occupied_square[2] > 0
            filter!(x->x!=first_occupied_square,diagonal_squares)
            first_occupied_square[1] -= 1
            first_occupied_square[2] -= 1
        end
    catch e
        println(e)
    end

    ### top right
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x->x==1, diagonal_squares_occupied)

    idx = findall(x->x[1]<j && x[2]>i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x-[j,i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (decreasing in j and increasing in i until either j hits 1 or i hits 15)
        while first_occupied_square[1] > 0 || first_occupied_square[2] < 16
            filter!(x->x!=first_occupied_square,diagonal_squares)
            first_occupied_square[1] -= 1
            first_occupied_square[2] += 1
        end
    catch e
    end
    
    ### bottom right
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x->x==1, diagonal_squares_occupied)

    idx = findall(x->x[1]>j && x[2]>i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x-[j,i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (increasing in j and i until either j hits 15)
        while first_occupied_square[1] < 16 || first_occupied_square[2] < 16
            filter!(x->x!=first_occupied_square,diagonal_squares)
            first_occupied_square[1] += 1
            first_occupied_square[2] += 1
        end
    catch e
    end 

    ### bottom left
    diagonal_squares_occupied = [OccupiedSquare(a..., board) for a in diagonal_squares]
    idxs = findall(x->x==1, diagonal_squares_occupied)

    idx = findall(x->x[1]>j && x[2]<i, diagonal_squares[idxs])

    try
        first_occupied_square = diagonal_squares[idxs][idx][argmin([norm(x-[j,i]) for x in diagonal_squares[idxs][idx]])]
        ### from diagonal_squares, delete this first occupied square and every square after (increasing in j and decreasing in i until either j hits 15 or i hits 1)
        while first_occupied_square[1] < 16 || first_occupied_square[2] > 0
            filter!(x->x!=first_occupied_square,diagonal_squares)
            first_occupied_square[1] += 1
            first_occupied_square[2] -= 1
        end
    catch e
    end

    ### push possible moves
    try
        push!(PossibleDwarfMoves,diagonal_squares)
    catch e
        ### if no moves found, push empty vector
        push!(PossibleDwarfMoves,[])
    end

    ### TODO sometimes a MethodError occurs here TODO TODO
    ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    ### not sure what happens - seems to still work...
    ### surpressed in try catch for now

    ### finally reduce to Vector{Int64}
    try
        PossibleDwarfMoves = reduce(vcat,PossibleDwarfMoves)
    catch e
    end
    
    return PossibleDwarfMoves
end

### j is row, i is column of selected troll in board matrix
function GetPossibleTrollMoves(j, i, board)
    
    ### start by getting square neighbours
    PossibleTrollMoves = GetSquareNeighbours(j, i, board)

    ### remove king / rock as possible move
    ### TODO make more general, i.e. remove piece that is labelled KING instead of specific position
    filter!(x->x!=[8,8],PossibleTrollMoves)

    ### remove possible moves which are OUTSIDE of board
    outside_idx = []
    for (idx,n) in enumerate(PossibleTrollMoves)
        if board[n...] == OUTSIDE
            push!(outside_idx,idx)
        end
    end
    deleteat!(PossibleTrollMoves,outside_idx)

    ### filter out the occupied neighbours
    occupied_idx = []
    for (idx,n) in enumerate(PossibleTrollMoves)
        if board[n...] != EMPTY
            push!(occupied_idx,idx)
        end
    end
    deleteat!(PossibleTrollMoves,occupied_idx)

    return PossibleTrollMoves
end

### captures are (mostly) optional!

### dwarves move like a chess queen
### from and to are of form [j, i]
function MoveDwarf(from, to, board)
    @assert board[from...] == DWARF
    @assert to ∈ GetPossibleDwarfMoves(from[1],from[2],board)

    board[from[1],from[2]] = EMPTY
    board[to[1],to[2]] = DWARF
    return board
end

### trolls move like a chess king
### from and to are of form [j, i]
function MoveTroll(from, to, board)
    @assert board[from...] == TROLL
    @assert to ∈ GetPossibleTrollMoves(from[1],from[2],board)

    board[from[1],from[2]] = EMPTY
    board[to[1],to[2]] = TROLL
    return board

    ### TODO after movement, troll has option to capture dwarves (should they always?)
    ### currently choosing to always capture surrounding dwarves after movement
    neighbours = GetSquareNeighbours(to[1], to[2], board)
    for n in neighbours
        if board[n...] == DWARF
            board[n...] = EMPTY
        end
    end

end

### get number of spaces between 'from' and 'to'
### first checking they share either a rank, file or diagonal
function GetNumberOfSpaces(from, to, board)

    @assert to ∈ GetRank(from...,board) || to ∈ GetFile(from...,board) || to ∈ GetDiagonals(from...,board)

    ### same row
    if from[1] == to[1]
        return abs(from[2] - to[2]) - 1

    ### same column
    elseif from[2] == to[2]
        return abs(from[1] - to[1]) - 1

    ### diagonal
    else
        return abs(from[1] - to[1]) - 1
    end
end

### get the squares between 'from' and 'to', return them of form [ [from[1],from[2]],[j_1,i_1],[j_2,i_2],...,[to[1],to[2]] ]
function GetSquaresBetween(from, to, board)
    @assert to ∈ GetRank(from...,board) || to ∈ GetFile(from...,board) || to ∈ GetDiagonals(from...,board)

    ### same row
    if from[1] == to[1]
        step = 1
        if to[2] < from[2]
            step = -1
        end
        return [ [from[1],k] for k in range(start=from[2],step=step,stop=to[2]) ]

    ### same column
    elseif from[2] == to[2]
        step = 1
        if to[1] < from[1]
            step = -1
        end
        return [ [k,from[2]] for k in range(start=from[1],step=step,stop=to[1]) ]

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

        return [[k,l] for (k,l) in zip(r1,r2)]
    end
end

### get squares on other side of [j,i] wrt 'to', same length (?) as GetNumberOfSpaces + 1
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

        return [ [from[1], k] for k in range(start,step=step,length=search_length)]

    ### same column
    elseif from[2] == to[2]

        start = from[1]
        step = 1
        if to[1] > from[1]
            step = -1
        end

        return [ [k, from[2]] for k in range(start,step=step,length=search_length) ]

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

        r1 = range(from[1],step=step1,length=search_length)
        r2 = range(from[2],step=step2,length=search_length)

        return [[k,l] for (k,l) in zip(r1,r2)]
    end
end

### j is row, i is column of selected dwarf in board matrix
function GetPossibleDwarfHurls(j, i, board)

    ### make huge vector of 'possible' hurls in rank, file, and diagonals - nothing else off limits here!
    PossibleDwarfHurls = Vector{Vector{Int64}}[]
    push!(PossibleDwarfHurls,GetRank(j, i, board))
    push!(PossibleDwarfHurls,GetFile(j, i, board))
    push!(PossibleDwarfHurls,GetDiagonals(j, i, board))

    ### TODO sometimes a MethodError occurs here TODO TODO
    ### not exactly below error, but something like it...
    ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    ### not sure what happens - seems to still work...
    ### surpressed in try catch for now

    ### reduce to Vector
    try
        PossibleDwarfHurls = reduce(vcat,PossibleDwarfHurls)
    catch e
    end

    # @show PossibleDwarfHurls

    ### first: dwarf MUST land on troll, all other options are impossible
    more_possible_idx = []
    for (idx,n) in enumerate(PossibleDwarfHurls)
        # println(n)
        # println(board[n...] == TROLL)
        # println()
        if board[n...] == TROLL
            push!(more_possible_idx,idx)
        end
    end

    ### if no captures possible, return empty list
    if more_possible_idx == []
        return []
    end

    PossibleDwarfHurls = PossibleDwarfHurls[more_possible_idx]

    # @show PossibleDwarfHurls

    ### next: get squares between dwarf and target troll
    ### all in between squares MUST be EMPTY
    impossible_idx = []
    for (idx,n) in enumerate(PossibleDwarfHurls)
        path = GetSquaresBetween([j,i], n, board)

        for p in path[2:end-1]
            if board[p...] != EMPTY
                push!(impossible_idx,idx)
                break
            end
        end
    end

    deleteat!(PossibleDwarfHurls,impossible_idx)

    # @show PossibleDwarfHurls

    ### if none possible here, no more checks required
    if PossibleDwarfHurls == []
        return PossibleDwarfHurls
    end

    ### finally: dwarf must have enough neighbours in row to hurl across space
    impossible_idx = []
    for (idx,n) in enumerate(PossibleDwarfHurls)
        path = GetSquaresOtherSide([j,i], n, board)

        for p in path
            try
                if board[p...] != DWARF
                    push!(impossible_idx,idx)
                    break
                end
            catch e
                # println("error here, but code may be working as intended")
                push!(impossible_idx,idx)
                break
            end
        end
    end

    deleteat!(PossibleDwarfHurls,impossible_idx)

    return PossibleDwarfHurls
end

function GetPossibleTrollShoves(j, i, board)

    ### make huge vector of 'possible' shoves in rank, file, and diagonals - nothing else off limits here!
    PossibleTrollShoves = Vector{Vector{Int64}}[]
    push!(PossibleTrollShoves,GetRank(j, i, board))
    push!(PossibleTrollShoves,GetFile(j, i, board))
    push!(PossibleTrollShoves,GetDiagonals(j, i, board))

    ### TODO sometimes a MethodError occurs here TODO TODO
    ### not exactly below error, but something like it...
    ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    ### not sure what happens - seems to still work...
    ### surpressed in try catch for now

    ### reduce to Vector
    try
        PossibleTrollShoves = reduce(vcat,PossibleTrollShoves)
    catch e
    end

    # @show PossibleTrollShoves

    ### first: troll MUST land NEXT TO at least one dwarf (and NOT ON a dwarf), all other options are impossible
    more_possible_idx = []
    for (idx,n) in enumerate(PossibleTrollShoves)
        if board[n...] == EMPTY
            neighbours = GetSquareNeighbours(n..., board)
            for n_ in neighbours
                if board[n_...] == DWARF
                    push!(more_possible_idx,idx)
                    break
                end
            end
        end
    end

    ### if no captures possible, return empty list
    if more_possible_idx == []
        return []
    end

    PossibleTrollShoves = PossibleTrollShoves[more_possible_idx]

    # @show PossibleTrollShoves

    ### next: get squares between troll and target dwarf
    ### all in between squares MUST be EMPTY
    impossible_idx = []
    for (idx,n) in enumerate(PossibleTrollShoves)
        path = GetSquaresBetween([j,i], n, board)

        for p in path[2:end-1]
            if board[p...] != EMPTY
                push!(impossible_idx,idx)
                break
            end
        end
    end

    deleteat!(PossibleTrollShoves,impossible_idx)

    # @show PossibleTrollShoves

    ### if none possible here, no more checks required
    if PossibleTrollShoves == []
        return PossibleTrollShoves
    end

    ### finally: troll must have enough neighbours in row to shove across space
    impossible_idx = []
    for (idx,n) in enumerate(PossibleTrollShoves)
        path = GetSquaresOtherSide([j,i], n, board)

        for p in path
            try
                if board[p...] != TROLL
                    push!(impossible_idx,idx)
                    break
                end
            catch e
                # println("error here, but code may be working as intended")
                push!(impossible_idx,idx)
                break
            end
        end
    end

    deleteat!(PossibleTrollShoves,impossible_idx)

    return PossibleTrollShoves
    
end

### dwarf capture move
### straight line of dwarves, hurl dwarf less than or equal to number of dwarves in line
### dwarf at front of line replaces position of targeted troll (which is captured)
### from and to are of form [j, i]
function HurlDwarf(from, to, board)
    @assert board[from...] == DWARF
    @assert to ∈ GetPossibleDwarfHurls(from[1],from[2],board)

    board[from[1],from[2]] = EMPTY
    board[to[1],to[2]] = DWARF
    return board

end

### troll (special) capture move - as trolls can also capture after normal movement
### straight line of trolls, shove troll less than or equal to number of trolls in line
### troll aims to land next to dwarves to capture
### troll MUST capture at least one dwarf if making this move
### i believe that with this move, all possible dwarves are captured
### from and to are of form [j, i]
function ShoveTroll(from, to, board)
    @assert board[from...] == TROLL
    @assert to ∈ GetPossibleTrollShoves(from[1],from[2],board)

    board[from[1],from[2]] = EMPTY
    board[to[1],to[2]] = TROLL

    ### currently choosing to always capture surrounding dwarves after movement
    neighbours = GetSquareNeighbours(to[1], to[2], board)
    for n in neighbours
        if board[n...] == DWARF
            board[n...] = EMPTY
        end
    end

    return board

end

### make a move from a string
### of form "AA-BB-CC-DD" where
### AA is either Dw or Tr , for dwarf or troll
### BB is square the piece is on, in file/rank notation e.g. C7, H1, P10
### CC is either Mv for move, Hu for Hurl (dwarves only), Sh for Shove (trolls only)
### DD is target square for chosen movement CC
### returns board
function MoveFromString!(board,move_string)

    ### first split move string into constituent parts
    piece, from_string, move_type, to_string = split(move_string,"-")

    # ### either "Dw" or "Tr"
    # piece = move_string[1:2]

    ### get 'from' and 'to' from 3rd, 4th, 7th, and 8th characters of move_string
    from = [parse(Int,from_string[2:end]),findfirst(x->x==string(from_string[1]),files)]
    to = [parse(Int,to_string[2:end]),findfirst(x->x==string(to_string[1]),files)]

    # ### either "Mv", "Hu" or "Sh" for move, hurl or shove
    # move_type = move_string[5:6]

    if (piece == "Dw" && move_type == "Sh") || (piece == "Tr" && move_type == "Hu")
        println("Impossible Move! Shoves / Hurls can only be done by Trolls / Dwarves!")
        return board
    elseif (piece == "Dw" && move_type == "Mv")
        board = MoveDwarf(from, to, board)
        return board
    elseif (piece == "Tr" && move_type == "Mv")
        board = MoveTroll(from, to, board)
        return board
    elseif (piece == "Tr" && move_type == "Sh")
        board = ShoveTroll(from, to, board)
        return board
    elseif (piece == "Dw" && move_type == "Hu")
        board = HurlDwarf(from, to, board)
        return board
    else
        println("No idea how you reached this error, but that input doesnt work")
        return board
    end
end

function GetDwarfPositions(board)
    DwarfPositions = []
    for row in 1:15
        for col in 1:15
            if board[row,col] == DWARF
                push!(DwarfPositions,[row,col])
            end
        end
    end
    return DwarfPositions
end

function GetTrollPositions(board)
    TrollPositions = []
    for row in 1:15
        for col in 1:15
            if board[row,col] == TROLL
                push!(TrollPositions,[row,col])
            end
        end
    end
    return TrollPositions
end

### returns three lists: current positions, candidate move positions and candidate capture positions
function GetPossibleMoves(board, PLAYER_TURN)
    
    if PLAYER_TURN
        ### dwarves move
        @assert CountDwarves(board) > 0

        Moves = []
        Hurls = []

        ### get where dwarves are
        DwarfPositions = GetDwarfPositions(board)

        ### for each, get possible moves
        for pos in DwarfPositions
            push!(Moves, GetPossibleDwarfMoves(pos[1], pos[2], board))
        end
        ### ...and hurls
        for pos in DwarfPositions
            push!(Hurls, GetPossibleDwarfHurls(pos[1], pos[2] ,board))
        end

        # ### collect both together
        # for idx in eachindex(Moves)
        #     Moves[idx] = vcat(Moves, Hurls)
        # end

        return DwarfPositions, Moves, Hurls

    else
        ### trolls move
        @assert CountTrolls(board) > 0

        Moves = []
        Shoves = []

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

        # ### collect both together
        # for idx in eachindex(Moves)
        #     Moves[idx] = vcat(Moves, Shoves)
        # end

        return TrollPositions, Moves, Shoves
    end

end

### assumes turn variable is correct! TODO fix
function MoveStringFromBoard(initial_pos, final_pos, PLAYER_TURN)
    
    a = ""
    if PLAYER_TURN
        a = "Dw"
    else
        a = "Tr"
    end

    return a * "-" * files[initial_pos[2]] * string(initial_pos[1]) * "-" * "Mv" * "-" * files[final_pos[2]] * string(final_pos[1])
end

### assumes turn variable is correct! TODO fix
function CaptureStringFromBoard(initial_pos, final_pos, PLAYER_TURN)

    a = ""
    c = ""
    if PLAYER_TURN
        a = "Dw"
        c = "Hu"
    else
        a = "Tr"
        c = "Sh"
    end

    return a * "-" * files[initial_pos[2]] * string(initial_pos[1]) * "-" * c * "-" * files[final_pos[2]] * string(final_pos[1])

end

### TODO finish
function CollectAllStrings(board, PLAYER_TURN)

    a,b,c = GetPossibleMoves(board, PLAYER_TURN)

    all_strings = []
    for i in eachindex(a)

        push!(all_strings, [MoveStringFromBoard(a[i],j,PLAYER_TURN) for j in b[i]])
        push!(all_strings, [CaptureStringFromBoard(a[i],j,PLAYER_TURN) for j in c[i]])

    end

    ### TODO sometimes a MethodError occurs here TODO TODO
    ### not exactly below error, but something like it...
    ### MethodError(Base.mapreduce_empty, (Base.var"#308#309"{typeof(identity)}(identity), Base.BottomRF{typeof(Base._rf_findmin)}(Base._rf_findmin), Pair{Int64, Any}), 0x00000000000083de)
    ### not sure what happens - seems to still work...
    ### surpressed in try catch for now

    ### reduce to Vector
    try
        all_strings = reduce(vcat, all_strings)
    catch e
    end

    return all_strings
end

### make (empty!) board
function MakeEmptyBoard(BOARD_SIZE)
    return fill(EMPTY, (BOARD_SIZE, BOARD_SIZE))
end

# Set the starting positions of the pieces
function StartPositions!(board)

    ### set entire board to empty
    board .= EMPTY

    ### set outside of board
    board[1,1:5] .= OUTSIDE
    board[1,11:15] .= OUTSIDE
    board[15,1:5] .= OUTSIDE
    board[15,11:15] .= OUTSIDE
    board[2,1:4] .= OUTSIDE
    board[2,12:15] .= OUTSIDE
    board[14,1:4] .= OUTSIDE
    board[14,12:15] .= OUTSIDE
    board[3,1:3] .= OUTSIDE
    board[3,13:15] .= OUTSIDE
    board[13,1:3] .= OUTSIDE
    board[13,13:15] .= OUTSIDE
    board[4,1:2] .= OUTSIDE
    board[4,14:15] .= OUTSIDE
    board[12,1:2] .= OUTSIDE
    board[12,14:15] .= OUTSIDE
    board[5,1:1] .= OUTSIDE
    board[5,15:15] .= OUTSIDE
    board[11,1:1] .= OUTSIDE
    board[11,15:15] .= OUTSIDE

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
    board[end,6] = DWARF
    board[end,7] = DWARF
    board[end,9] = DWARF
    board[end,10] = DWARF
end

function TestHurlBoard!(board)
    
    ### set entire board to empty
    board .= EMPTY

    ### set outside of board
    board[1,1:5] .= OUTSIDE
    board[1,11:15] .= OUTSIDE
    board[15,1:5] .= OUTSIDE
    board[15,11:15] .= OUTSIDE
    board[2,1:4] .= OUTSIDE
    board[2,12:15] .= OUTSIDE
    board[14,1:4] .= OUTSIDE
    board[14,12:15] .= OUTSIDE
    board[3,1:3] .= OUTSIDE
    board[3,13:15] .= OUTSIDE
    board[13,1:3] .= OUTSIDE
    board[13,13:15] .= OUTSIDE
    board[4,1:2] .= OUTSIDE
    board[4,14:15] .= OUTSIDE
    board[12,1:2] .= OUTSIDE
    board[12,14:15] .= OUTSIDE
    board[5,1:1] .= OUTSIDE
    board[5,15:15] .= OUTSIDE
    board[11,1:1] .= OUTSIDE
    board[11,15:15] .= OUTSIDE

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
    board[1,1:5] .= OUTSIDE
    board[1,11:15] .= OUTSIDE
    board[15,1:5] .= OUTSIDE
    board[15,11:15] .= OUTSIDE
    board[2,1:4] .= OUTSIDE
    board[2,12:15] .= OUTSIDE
    board[14,1:4] .= OUTSIDE
    board[14,12:15] .= OUTSIDE
    board[3,1:3] .= OUTSIDE
    board[3,13:15] .= OUTSIDE
    board[13,1:3] .= OUTSIDE
    board[13,13:15] .= OUTSIDE
    board[4,1:2] .= OUTSIDE
    board[4,14:15] .= OUTSIDE
    board[12,1:2] .= OUTSIDE
    board[12,14:15] .= OUTSIDE
    board[5,1:1] .= OUTSIDE
    board[5,15:15] .= OUTSIDE
    board[11,1:1] .= OUTSIDE
    board[11,15:15] .= OUTSIDE

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



### update trackers of board / game
function UpdateTrackers(move_tracker, eval_tracker, num_dwarves_tracker, num_trolls_tracker, board, move_string, number_turns)
    push!(move_tracker, move_string)
    push!(eval_tracker, EvaluateBoard(board))
    push!(num_dwarves_tracker, CountDwarves(board))
    push!(num_trolls_tracker, CountTrolls(board))
    number_turns += 1
end

### TODO
### make start board again, remove most recent move from move_tracker, run through moves to get back to previous
function UndoMove!(board, move_tracker)

    StartPositions!(board)
    pop!(move_tracker)

    for move in move_tracker

        MoveFromString!(board, move)

    end

    return board, move_tracker
    
end

function GetRandomMove(board, PLAYER_TURN)
    if PLAYER_TURN
        p,m,c = GetPossibleMoves(board, PLAYER_TURN)
    else
        p,m,c = GetPossibleMoves(board, !PLAYER_TURN)
    end

    

end

function GetBestMove(depth, board)
    
end