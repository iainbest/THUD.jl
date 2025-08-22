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
    from = [parse(Int, from_string[2:end]), findfirst(x -> x == string(from_string[1]), files)]
    to = [parse(Int, to_string[2:end]), findfirst(x -> x == string(to_string[1]), files)]

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

### get move string from board move
function MoveStringFromBoard(initial_pos, final_pos, dwarf_turn)

    a = ""
    if dwarf_turn[]
        a = "Dw"
    else
        a = "Tr"
    end

    return a * "-" * files[initial_pos[2]] * string(initial_pos[1]) * "-" * "Mv" * "-" * files[final_pos[2]] * string(final_pos[1])
end

### get capture string from board move
function CaptureStringFromBoard(initial_pos, final_pos, dwarf_turn)

    a = ""
    c = ""
    if dwarf_turn[]
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

    a, b, c = GetAllPossibleMoves(board, PLAYER_TURN)

    all_strings = []
    for i in eachindex(a)

        push!(all_strings, [MoveStringFromBoard(a[i], j, PLAYER_TURN) for j in b[i]])
        push!(all_strings, [CaptureStringFromBoard(a[i], j, PLAYER_TURN) for j in c[i]])

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