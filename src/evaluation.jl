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
        neighbours = GetSquareNeighbours(dwarf_pos[1], dwarf_pos[2], board)
        average_dwarf_neighbours += count(==(DWARF), [board[n_...] for n_ in neighbours])
    end
    average_dwarf_neighbours /= CountDwarves(board)
    return average_dwarf_neighbours
end

### get number of unique! threatened trolls
function GetThreatenedTrolls(board)
    poss_trolls = GetTrollPositions(board)
    a = length(poss_trolls)
    for dwarf_pos in GetDwarfPositions(board)
        poss_hurls = GetPossibleDwarfHurls(dwarf_pos[1], dwarf_pos[2], board)
        for hurl in poss_hurls
            if hurl ∈ poss_trolls
                filter!(x -> x != hurl, poss_trolls)
            end
        end
    end
    b = length(poss_trolls)
    return a - b
end

### get number of unique threatened dwarves
function GetThreatenedDwarves(board)
    poss_dwarves = GetDwarfPositions(board)
    a = length(poss_dwarves)
    for troll_pos in GetTrollPositions(board)
        ### get possible troll moves. for those that land next to dwarves, count number of dwarves
        troll_moves = GetPossibleTrollMoves(troll_pos[1], troll_pos[2], board)
        for move in troll_moves
            neighbours = GetSquareNeighbours(move[1], move[2], board)
            ### filter neighbours for dwarves
            filter!(x -> board[x...] == DWARF, neighbours)
            for n in neighbours
                if n ∈ poss_dwarves
                    filter!(x -> x != n, poss_dwarves)
                end
            end
        end

        ### get possible troll shoves
        troll_shoves = GetPossibleTrollShoves(troll_pos[1], troll_pos[2], board)
        for shove in troll_shoves
            neighbours = GetSquareNeighbours(shove[1], shove[2], board)
            ### filter neighbours for dwarves
            filter!(x -> board[x...] == DWARF, neighbours)
            for n in neighbours
                if n ∈ poss_dwarves
                    filter!(x -> x != n, poss_dwarves)
                end
            end
        end
    end
    b = length(poss_dwarves)
    return a - b
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