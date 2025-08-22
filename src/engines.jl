struct RandomEngine end

struct MinimaxEngine
    depth::Int
    use_alpha_beta::Bool
end

### get a random move
function GetEngineMove(engine::RandomEngine, board)
    
    positions, m, c = GetAllPossibleMoves(board, dwarf_turn)

    ### check if empty; if so no possible moves & game is over
    @assert !isempty(positions)
    
    ### choose random piece (TODO is this a fair way to do this?)
    idx = rand(eachindex(positions[1]))

    ### get possible captures + moves for that piece & choose randomly between them
    move = rand(vcat(m[idx], c[idx]))

    return move

end

### TODO check minimax
function GetEngineMove(engine::MinimaxEngine, board)
    _, move = minimax(board, engine.depth, true, dwarf_turn[]; α=-Inf, β=Inf, use_alpha_beta = engine.use_alpha_beta)

    return move
end


### TODO: implement check if game is in terminal state
### probably requires game play to determine this
function is_terminal(board)
    return false
end


### player is either dwarf_turn or !dwarf_turn (i.e. troll turn)
### maximising_player is true/false depending on level of recursion
### EvaluateBoard should return higher value for better position for player (!) 
### TODO check
function minimax(board, depth, maximizing_player, player; α=-Inf, β=Inf, use_alpha_beta=false)
    if player && depth == 0 || is_terminal(board)
        return EvaluateBoard(board), nothing
    elseif !player && depth == 0 || is_terminal(board)
        return -EvaluateBoard(board), nothing
    end

    move_strings = CollectAllStrings(board, player)
    # moves = generate_moves(board, player)
    if isempty(move_strings)
        return EvaluateBoard(board), nothing
    end

    best_move = nothing

    if maximizing_player
        max_eval = -Inf
        for move in move_strings
            new_board = MoveFromString(board, move)
            eval, _ = minimax(new_board, depth-1, false, !player; α=α, β=β, use_alpha_beta=use_alpha_beta)
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
        return max_eval, best_move
    else
        min_eval = Inf
        for move in move_strings
            new_board = MoveFromString(board, move)
            eval, _ = minimax(new_board, depth-1, true, !player; α=α, β=β, use_alpha_beta=use_alpha_beta)
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
        return min_eval, best_move
    end
end