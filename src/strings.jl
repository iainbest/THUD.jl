### make a move from a string
### strings are of form "AA-BB-CC-DD" where
### AA is either Dw or Tr , for dwarf or troll
### BB is square the piece is on, in file/rank notation e.g. C7, H1, P10
### CC is either Mv for move, Hu for Hurl (dwarves only), Sh for Shove (trolls only)
### DD is target square for chosen movement CC
### returns board
### TODO refactor? 
function MoveFromString!(board, move_string)

    ### first split move string into constituent parts
    piece, from_string, move_type, to_string = split(move_string, "-")

    ### get 'from' and 'to' from characters of from_string and to_string moves
    # use precomputed file_index dict for faster mapping from file-char -> column index
    fch = from_string[1]
    tch = to_string[1]
    fidx = get(file_index, fch, findfirst(x -> x[1] == fch, files))
    tidx = get(file_index, tch, findfirst(x -> x[1] == tch, files))
    from = SVector{2,Int}(parse(Int, from_string[2:end]), fidx)
    to = SVector{2,Int}(parse(Int, to_string[2:end]), tidx)

    if (piece == "Dw" && move_type == "Sh") || (piece == "Tr" && move_type == "Hu")
        println("Impossible Move! Shoves / Hurls can only be done by Trolls / Dwarves!")
        return board
    elseif (piece == "Dw" && move_type == "Mv")
        board = MoveDwarf!(from, to, board)
        return board
    elseif (piece == "Tr" && move_type == "Mv")
        board = MoveTroll!(from, to, board)
        return board
    elseif (piece == "Tr" && move_type == "Sh")
        board = ShoveTroll!(from, to, board)
        return board
    elseif (piece == "Dw" && move_type == "Hu")
        board = HurlDwarf!(from, to, board)
        return board
    else
        println("No idea how you reached this error, but that input doesnt work")
        return board
    end
end

 ###TODO make non-mutating version of above function
function MoveFromString(board, move_string)

    new_board = deepcopy(board)
    ### first split move string into constituent parts
    piece, from_string, move_type, to_string = split(move_string, "-")

    ### get 'from' and 'to' from characters of from_string and to_string moves
    fch = from_string[1]
    tch = to_string[1]
    fidx = get(file_index, fch, findfirst(x -> x[1] == fch, files))
    tidx = get(file_index, tch, findfirst(x -> x[1] == tch, files))
    from = SVector{2,Int}(parse(Int, from_string[2:end]), fidx)
    to = SVector{2,Int}(parse(Int, to_string[2:end]), tidx)

    if (piece == "Dw" && move_type == "Sh") || (piece == "Tr" && move_type == "Hu")
        println("Impossible Move! Shoves / Hurls can only be done by Trolls / Dwarves!")
        return new_board
    elseif (piece == "Dw" && move_type == "Mv")
        new_board = MoveDwarf!(from, to, new_board)
        return new_board
    elseif (piece == "Tr" && move_type == "Mv")
        new_board = MoveTroll!(from, to, new_board)
        return new_board
    elseif (piece == "Tr" && move_type == "Sh")
        new_board = ShoveTroll!(from, to, new_board)
        return new_board
    elseif (piece == "Dw" && move_type == "Hu")
        new_board = HurlDwarf!(from, to, new_board)
        return new_board
    else
        println("No idea how you reached this error, but that input doesnt work")
        return new_board
    end
end

### get move string from board move
function MoveStringFromBoard(initial_pos, final_pos, dwarf_turn)

    @inbounds begin
        a = dwarf_turn[] ? "Dw" : "Tr"
        return string(a, "-", files[initial_pos[2]], initial_pos[1], "-Mv-", files[final_pos[2]], final_pos[1])
    end
end

### get capture string from board move
function CaptureStringFromBoard(initial_pos, final_pos, dwarf_turn)

    @inbounds begin
        (a,c) = dwarf_turn[] ? ("Dw","Hu") : ("Tr","Sh")
        return string(a, "-", files[initial_pos[2]], initial_pos[1], "-$(c)-", files[final_pos[2]], final_pos[1])
    end

end

### TODO check this works
function CollectAllStrings(board, PLAYER_TURN)

    a, b, c = GetAllPossibleMoves(board, PLAYER_TURN)

    # precompute total number of strings to avoid push! churn
    total = 0
    for i in eachindex(a)
        # c[i] or b[i] may be empty collections or contain SVector elements
        total += sum(!isempty(b[i]) ? length(b[i]) : 0)
        total += sum(!isempty(c[i]) ? length(c[i]) : 0)
    end

    if total == 0
        return String[]
    end

    all_strings = Vector{String}(undef, total)
    idx = 1
    for i in eachindex(a)
        for j in c[i]
            if isempty(j)
                continue
            end
            all_strings[idx] = CaptureStringFromBoard(a[i], j, PLAYER_TURN)
            idx += 1
        end
        for j in b[i]
            if isempty(j)
                continue
            end
            all_strings[idx] = MoveStringFromBoard(a[i], j, PLAYER_TURN)
            idx += 1
        end
    end

    return all_strings
end