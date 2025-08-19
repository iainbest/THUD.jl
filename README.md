# THUD.jl
A simple recreation of the Discworld boardgame THUD in the Julia language.



### THUD notes

some notes:
- unsure how to deal with captures being optional (?)
    - as a troll, almost certainly no situation where not capturing is advantageous (on coming back to this, this statement seems wrong...)
    - does this simply mean that a piece under attack does not have to be captured? 
- how to measure state of board? `EvaluateBoard(board)` function in  
    - simple score for remaining pieces is trivial ~~& implemented~~
    - but this is not so simple: from guide, dwarf strategy seems to depend on building formations / blocks of dwarves (and the trolls on preventing this)
    - see `evaluation.jl` for some more detail
- how to state when game over? 
    - it is a decision from both players to stop when captures no longer possible / likely
    - could simply have a turn limit
    - or if no captures made in x moves, finish game
    - repetition unlikely to be feasible due to size of board etc., although there is some symmetry to the board we could exploit


quick todo:
    - ~~undo move function?~~
    - compartmentalise / tidy up existing codebase!
    - highlight possible moves based on query square (highlight possible moves and captures in different colours)
    - go from board / matrix representation to string move representation (reverse is implemented)
    - simple engine (random moves)
    - player vs engine
    - engine vs engine
    - slightly more sophisticated learning (minimax / tree search)


some cool facts!
- 656 possible opening moves for dwarves
    - `positions, moves, captures = GetPossibleMoves(board, turn)` with turn=1 on starting board
    - then `sum(length.(moves))`
- approx 32 openings for trolls (some variance for some dwarf openings)
    - turn=2, same as above
