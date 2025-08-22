struct RandomEngine



end

struct MinimaxEngine
    depth::Int
    use_alpha_beta::Bool
    use_move_ordering::Bool
    use_transposition_table::Bool
    use_quiescence_search::Bool
    transposition_table::Dict{UInt64, Any}

end