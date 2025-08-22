# THUD.jl
A simple recreation of the Discworld boardgame THUD in the Julia language. I intend to use this to test out different game engines (e.g. random move selection, minimax search at different depths, possibly others) to investigate the game & its rules.

### TODO:
#### 'urgent'
- add `is_terminal` function to check if game over 
    - separate function for if engine is ready to concede? or should engine always keep going (even if this may lead to even worse position)
    - how to state when game over? 
        - it is a decision from both players to stop when captures no longer possible / likely
        - could simply have a turn limit
        - or if no captures made in x moves, finish game
        - repetition unlikely to be feasible due to size of board etc., although there is some symmetry to the board we could exploit
#### Misc
- currently, troll captures are non optional -- i believe this is the correct interpretation of the rules
- ~~undo move function?~~ - Done, check this still works
- WIP compartmentalise / tidy up existing codebase!
- add some discworld flavour to the player experience...

#### Makie Plotting
- ~~move from plots to makie? see `printing.jl` for links~~
- ~~highlight possible moves based on query square (highlight possible moves and captures in different colours)~~ - Done, can edit visuals later
- change glmakie window icon (see [here](https://discourse.julialang.org/t/change-window-icon-in-glmakie/93517))
- go from board / matrix representation to string move representation (reverse is implemented) - Maybe done, check etc.

  
#### Engines
- how to measure state of board? `EvaluateBoard(board)` function in  
    - simple score for remaining pieces is trivial ~~& implemented~~
    - but this is not so simple: from guide, dwarf strategy seems to depend on building formations / blocks of dwarves (and the trolls on preventing this)
    - see `evaluation.jl` for some more detail
- ~~simple engine (random moves)~~
- ~~player vs engine~~
- engine vs engine
- slightly more sophisticated learning (minimax / tree search / reinforcement learning)
    - test minimax


### some cool facts!
- 656 possible opening moves for dwarves
    - `positions, moves, captures = GetPossibleMoves(board, turn)` with turn=1 on starting board
    - then `sum(length.(moves))`
- approx 32 openings for trolls (some variance for some (strange) dwarf openings)
    - turn=2, same as above
