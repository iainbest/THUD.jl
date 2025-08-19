### see https://github.com/lhartikk/simple-chess-ai/blob/master/script.js


function minimaxRoot(depth, board, turn, board_tracker, maximise_dwarves)

    moves = CollectAllStrings(board, turn)
    @show length(moves)
    BestMove = -Inf
    BestMoveFound = nothing
    
    for i in eachindex(moves)

        MoveFromString(board, moves[i])

        val = minimax(depth-1, board, turn, board_tracker, -Inf, Inf, !maximise_dwarves)

        board = board_tracker[end]
        # UndoMove(board, board_tracker)

        if val >= BestMove
            BestMove = val
            BestMoveFound = moves[i]
        end

    end

    return BestMoveFound

end


function minimax(depth, board, turn, board_tracker, alpha, beta, maximise_dwarves)
    # position_count+=1

    if depth == 0
        return -EvaluateBoard(board)
    end

    if maximise_dwarves
        BestMove = -Inf
        turn = 2

        ### trolls possible moves
        moves = CollectAllStrings(board, turn)

        for i in eachindex(moves)

            MoveFromString(board, moves[i])

            BestMove = maximum(BestMove, minimax(depth-1, board, turn, board_tracker, alpha, beta, !maximise_dwarves))

            board = board_tracker[end]
            # UndoMove(board, board_tracker)

            alpha = maximum(alpha, BestMove)

            if beta <= alpha
                return BestMove
            end

        end

        return BestMove

    else

        BestMove = Inf
        turn = 1

        ### dwarves possible moves
        moves = CollectAllStrings(board, turn)

        for i in eachindex(moves)

            MoveFromString(board, moves[i])

            BestMove = minimum(BestMove,minimax(depth-1, board, turn, board_tracker, alpha, beta, !maximise_dwarves))

            board = board_tracker[end]
            # UndoMove(board, board_tracker)

            beta = minimum(beta, BestMove)

            if beta <= alpha
                return BestMove
            end

        end

        return BestMove

    end

end
