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
    dwarves = GetDwarfPositions(board)
    num_dwarves = length(dwarves)
    if num_dwarves == 0
        return 0.0
    end
    total_neighbours = 0
    @inbounds for d in dwarves
        for n in GetSquareNeighbours(d[1], d[2])
            total_neighbours += (board[n[1], n[2]] == DWARF) ? 1 : 0
        end
    end
    return total_neighbours / num_dwarves
end

### get number of unique! threatened trolls
function GetThreatenedTrolls(board)
    # Use BitVector masks indexed by linear index to avoid Set allocations
    s = BOARD_SIZE
    N = s * s
    trolls = GetTrollPositions(board)
    if isempty(trolls)
        return 0
    end
    troll_mask = falses(N)
    @inbounds for p in trolls
        idx = (p[1]-1)*s + p[2]
        troll_mask[idx] = true
    end

    threatened_mask = falses(N)
    threatened_count = 0
    @inbounds for d in GetDwarfPositions(board)
        for h in GetPossibleDwarfHurls(d[1], d[2], board)
            idx = (h[1]-1)*s + h[2]
            if troll_mask[idx] && !threatened_mask[idx]
                threatened_mask[idx] = true
                threatened_count += 1
            end
        end
    end
    return threatened_count
end

### get number of unique threatened dwarves
function GetThreatenedDwarves(board)
    s = BOARD_SIZE
    N = s * s
    dwarves = GetDwarfPositions(board)
    if isempty(dwarves)
        return 0
    end
    dwarf_mask = falses(N)
    @inbounds for p in dwarves
        dwarf_mask[(p[1]-1)*s + p[2]] = true
    end

    threatened_mask = falses(N)
    threatened_count = 0
    @inbounds for tpos in GetTrollPositions(board)
        # possible normal troll moves
        for mv in GetPossibleTrollMoves(tpos[1], tpos[2], board)
            for nb in GetSquareNeighbours(mv[1], mv[2])
                if board[nb[1], nb[2]] == DWARF
                    idx = (nb[1]-1)*s + nb[2]
                    if dwarf_mask[idx] && !threatened_mask[idx]
                        threatened_mask[idx] = true
                        threatened_count += 1
                    end
                end
            end
        end

        # possible troll shoves
        for sv in GetPossibleTrollShoves(tpos[1], tpos[2], board)
            for nb in GetSquareNeighbours(sv[1], sv[2])
                if board[nb[1], nb[2]] == DWARF
                    idx = (nb[1]-1)*s + nb[2]
                    if dwarf_mask[idx] && !threatened_mask[idx]
                        threatened_mask[idx] = true
                        threatened_count += 1
                    end
                end
            end
        end
    end
    return threatened_count
end

### how to take into consideration more states of game, e.g.
###   fraction of dwarves / trolls remaining - done by evaluating piece values
###   how many moves made - needed? not added.
###   blocks / structures made by dwarves - currently getting average number of neighbours, higher than start board is better
###   number of possible attacks for trolls / dwarves - currently done by counting unique number of threatened dwarves / trolls
### +'ve for dwarves, -'ve for trolls
function EvaluateBoard(board)
    # compute piece values once to avoid multiple counts inside helpers
    piece_value = EvaluatePieceValues(board)
    avg_neigh = GetAverageDwarfNeighbours(board)
    threatened_trolls = GetThreatenedTrolls(board)
    threatened_dwarves = GetThreatenedDwarves(board)
    return piece_value + (avg_neigh - 1.75) + (threatened_trolls * 2) - (threatened_dwarves * 0.5)
end