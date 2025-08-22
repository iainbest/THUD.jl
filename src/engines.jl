struct RandomEngine end

struct MinimaxEngine
    engine_type::Symbol
    depth::Int
    use_alpha_beta::Bool
    use_move_ordering::Bool
    use_transposition_table::Bool
    use_quiescence_search::Bool
    transposition_table::Dict{UInt64, Any}

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

    return 
end

function GetEngineMove(engine::MinimaxEngine, board)
    
end