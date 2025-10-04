function CountDwarves(board)
    return count(==(DWARF), board)
end

function CountTrolls(board)
    return count(==(TROLL), board)
end

### dwarves are worth 1 point each
### trolls are worth 4 points each
function EvaluatePieceValues(board)
    return (CountDwarves(board) * 1) - (CountTrolls(board) * 4)
end

function GetAverageDwarfNeighbours(board)
    average_dwarf_neighbours = 0
    for dwarf_pos in GetDwarfPositions(board)
        neighbours = GetSquareNeighbours(dwarf_pos[1], dwarf_pos[2])
        average_dwarf_neighbours += count(==(DWARF), [board[n_...] for n_ in neighbours])
    end
    average_dwarf_neighbours /= CountDwarves(board)
    return average_dwarf_neighbours
end

### get number of unique! threatened trolls
function GetThreatenedTrolls(board)
    # Build a set of troll positions for fast membership tests
    trolls = GetTrollPositions(board)
    troll_set = Set{Tuple{Int,Int}}(((p[1], p[2]) for p in trolls))

    threatened = Set{Tuple{Int,Int}}()
    for d in GetDwarfPositions(board)
        for h in GetPossibleDwarfHurls(d[1], d[2], board)
            t = (h[1], h[2])
            if t in troll_set
                push!(threatened, t)
            end
        end
    end

    return length(threatened)
end

### get number of unique threatened dwarves
function GetThreatenedDwarves(board)
    # We want the number of unique dwarves that can be threatened by any troll move
    dwarves = GetDwarfPositions(board)
    dwarf_set = Set{Tuple{Int,Int}}(((p[1], p[2]) for p in dwarves))

    threatened = Set{Tuple{Int,Int}}()
    for tpos in GetTrollPositions(board)
        # possible normal troll moves
        for mv in GetPossibleTrollMoves(tpos[1], tpos[2], board)
            for nb in GetSquareNeighbours(mv[1], mv[2])
                if board[nb...] == DWARF
                    coord = (nb[1], nb[2])
                    if coord in dwarf_set
                        push!(threatened, coord)
                    end
                end
            end
        end

        # possible troll shoves
        for sv in GetPossibleTrollShoves(tpos[1], tpos[2], board)
            for nb in GetSquareNeighbours(sv[1], sv[2])
                if board[nb...] == DWARF
                    coord = (nb[1], nb[2])
                    if coord in dwarf_set
                        push!(threatened, coord)
                    end
                end
            end
        end
    end

    return length(threatened)
end

### how to take into consideration more states of game, e.g.
###   fraction of dwarves / trolls remaining - done by evaluating piece values
###   how many moves made - needed? not added.
###   blocks / structures made by dwarves - currently getting average number of neighbours, higher than start board is better
###   number of possible attacks for trolls / dwarves - currently done by counting unique number of threatened dwarves / trolls
### +'ve for dwarves, -'ve for trolls
function EvaluateBoard(board)

    return EvaluatePieceValues(board) +
           (GetAverageDwarfNeighbours(board) - 1.75) +
           (GetThreatenedTrolls(board) * 2) -
           (GetThreatenedDwarves(board) * 0.5)
end