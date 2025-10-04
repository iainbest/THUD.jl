struct RandomEngine end

struct MinimaxEngine
    depth::Int
    use_alpha_beta::Bool
end

mutable struct TTEntry
    depth::Int
    eval::Float64
    best_move::Union{String, Nothing}
    flag::Symbol # :exact, :lower, :upper
    time::Int
end

# Zobrist hashing table: dimensions (row, col, piece_index)
const _zobrist_table = Ref{Array{UInt64,3}}()
const TT_CAPACITY = 50_000
const transposition_table = Dict{UInt64, TTEntry}()
const _tt_time = Ref(0)


function init_zobrist!()
    rng = MersenneTwister(0)
    num_piece_types = 5 # EMPTY, DWARF, TROLL, KING, OUTSIDE
    tbl = Array{UInt64,3}(undef, BOARD_SIZE, BOARD_SIZE, num_piece_types)
    for r in 1:BOARD_SIZE, c in 1:BOARD_SIZE, p in 1:num_piece_types
        tbl[r, c, p] = rand(rng, UInt64)
    end
    _zobrist_table[] = tbl
    return
end

function zobrist_hash(board)
    tbl = _zobrist_table[]
    h = UInt64(0)
    @inbounds for r in 1:BOARD_SIZE
        for c in 1:BOARD_SIZE
            p = board[r, c] + 1 # map piece constants (0..4) to 1..5
            h ⊻= tbl[r, c, p]
        end
    end
    return h
end

function tt_store!(key::UInt64, entry::TTEntry)
    _tt_time[] += 1
    entry.time = _tt_time[]
    transposition_table[key] = entry
    # simple eviction: if over capacity, remove oldest entry (min time)
    if length(transposition_table) > TT_CAPACITY
        # find key with minimum time
        mink = nothing
        mint = typemax(Int)
        for (k, v) in transposition_table
            if v.time < mint
                mint = v.time
                mink = k
            end
        end
        if mink !== nothing
            delete!(transposition_table, mink)
        end
    end
end

# const transposition_table = Dict{UInt64, Tuple{Int, Float64}}()

### get a random move
function GetEngineMove(engine::RandomEngine, board)
    
    move_strings = CollectAllStrings(board, dwarf_turn[])

    ### TODO check if necessary? 
    ### check if empty; if so no possible moves & game is over
    @assert !isempty(move_strings) 

    ### get possible captures + moves for that piece & choose randomly between them
    move = rand(move_strings)

    return move

end

### TODO check minimax
function GetEngineMove(engine::MinimaxEngine, board)
    _, move = minimax(board, engine.depth, true, dwarf_turn[]; α=-Inf, β=Inf, use_alpha_beta = engine.use_alpha_beta)

    return move
end


### TODO: implement check if game is in terminal state
### probably requires game play to determine/tweak this
### number_turns[] > odd so that second engine ends the game
function IsBoardTerminal(board)
    if number_turns[] > 29 || CountDwarves(board) == 0 || CountTrolls(board) == 0
        return true
    else
        return false
    end
end


### lightweight move parsing helper: returns (piece_str, from_tuple, move_type_str, to_tuple)
function parse_move_string(move_string::AbstractString)
    piece, from_string, move_type, to_string = split(move_string, "-")
    from = SVector{2,Int}(parse(Int, from_string[2:end]), findfirst(x -> x == string(from_string[1]), files))
    to = SVector{2,Int}(parse(Int, to_string[2:end]), findfirst(x -> x == string(to_string[1]), files))
    return piece, from, move_type, to
end

### apply a move in-place and return a list of changed cells (r,c,oldvalue) so it can be undone cheaply
function apply_move_record!(board, move_string::AbstractString)
    piece, from, move_type, to = parse_move_string(move_string)
    changes = Vector{Tuple{Int,Int,Int}}()

    # helper to record a cell before changing
    record!(r, c) = push!(changes, (r, c, board[r, c]))

    if piece == "Dw" && move_type == "Mv"
        # MoveDwarf!: from -> to
        record!(from[1], from[2])
        record!(to[1], to[2])
        board[from[1], from[2]] = EMPTY
        board[to[1], to[2]] = DWARF

    elseif piece == "Dw" && move_type == "Hu"
        # HurlDwarf!: dwarf replaces troll at to
        record!(from[1], from[2])
        record!(to[1], to[2])
        board[from[1], from[2]] = EMPTY
        board[to[1], to[2]] = DWARF

    elseif piece == "Tr" && move_type == "Mv"
        # MoveTroll!: move and then capture adjacent dwarves
        record!(from[1], from[2])
        record!(to[1], to[2])
        board[from[1], from[2]] = EMPTY
        board[to[1], to[2]] = TROLL
        for nb in GetSquareNeighbours(to[1], to[2])
            if board[nb[1], nb[2]] == DWARF
                record!(nb[1], nb[2])
                board[nb[1], nb[2]] = EMPTY
            end
        end

    elseif piece == "Tr" && move_type == "Sh"
        # ShoveTroll!: move and clear neighbouring dwarves
        record!(from[1], from[2])
        record!(to[1], to[2])
        board[from[1], from[2]] = EMPTY
        board[to[1], to[2]] = TROLL
        for nb in GetSquareNeighbours(to[1], to[2])
            if board[nb[1], nb[2]] == DWARF
                record!(nb[1], nb[2])
                board[nb[1], nb[2]] = EMPTY
            end
        end

    else
        # unknown or invalid move; do nothing
    end

    return changes
end

function undo_move_record!(board, changes::Vector{Tuple{Int,Int,Int}})
    # restore in reverse order just in case
    for (r, c, old) in Iterators.reverse(changes)
        board[r, c] = old
    end
    return
end


### player is either dwarf_turn or !dwarf_turn (i.e. troll turn)
### maximising_player is true/false depending on level of recursion
### EvaluateBoard should return higher value for better position for player (!) 
### TODO check
function minimax(board, depth, maximizing_player, player; α=-Inf, β=Inf, use_alpha_beta=false)
    ### terminal or depth check
    if depth == 0 || IsBoardTerminal(board)
        val = EvaluateBoard(board)
        out = player ? val : -val
        # store in transposition table
        try
            transposition_table[UInt(hash(board))] = (depth, out)
        catch
        end
        return out, nothing
    end

    ### collect legal moves once
    move_strings = CollectAllStrings(board, player)
    if isempty(move_strings)
        val = EvaluateBoard(board)
        out = player ? val : -val
        try
            transposition_table[UInt(hash(board))] = (depth, out)
        catch
        end
        return out, nothing
    end

    ### check transposition table using zobrist hash
    key = zobrist_hash(board)
    if haskey(transposition_table, key)
        entry = transposition_table[key]
        if entry.depth >= depth
            if entry.flag == :exact
                return entry.eval, entry.best_move
            elseif entry.flag == :lower && entry.eval >= β
                return entry.eval, entry.best_move
            elseif entry.flag == :upper && entry.eval <= α
                return entry.eval, entry.best_move
            end
        end
    end

    ### simple move ordering: score each move by applying in-place, evaluating, and undoing
    scored = Vector{Tuple{String,Float64}}()
    for m in move_strings
        changes = apply_move_record!(board, m)
        s = EvaluateBoard(board)
        undo_move_record!(board, changes)
        push!(scored, (m, s))
    end
    if maximizing_player
        scored = sort(scored; by = x -> -x[2])
    else
        scored = sort(scored; by = x -> x[2])
    end

    best_move = nothing

    if maximizing_player
        max_eval = -Inf
        for (move,_) in scored
            changes = apply_move_record!(board, move)
            eval, _ = minimax(board, depth-1, false, !player; α=α, β=β, use_alpha_beta=use_alpha_beta)
            undo_move_record!(board, changes)
            if eval > max_eval
                max_eval = eval
                best_move = move
            end
            if use_alpha_beta
                α = max(α, eval)
                if β <= α
                    break
                end
            end
        end
        # store in transposition table
        flag = :exact
        # If alpha-beta was active and we had a cutoff, adjust flag
        if use_alpha_beta && max_eval <= α
            flag = :upper
        elseif use_alpha_beta && max_eval >= β
            flag = :lower
        end
        tt_store!(key, TTEntry(depth, max_eval, best_move, flag, 0))
        return max_eval, best_move
    else
        min_eval = Inf
        for (move,_) in scored
            changes = apply_move_record!(board, move)
            eval, _ = minimax(board, depth-1, true, !player; α=α, β=β, use_alpha_beta=use_alpha_beta)
            undo_move_record!(board, changes)
            if eval < min_eval
                min_eval = eval
                best_move = move
            end
            if use_alpha_beta
                β = min(β, eval)
                if β <= α
                    break
                end
            end
        end
        # store in transposition table
        flag = :exact
        if use_alpha_beta && min_eval <= α
            flag = :upper
        elseif use_alpha_beta && min_eval >= β
            flag = :lower
        end
        tt_store!(key, TTEntry(depth, min_eval, best_move, flag, 0))
        return min_eval, best_move
    end
end