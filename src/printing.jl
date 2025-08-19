### might be worth swapping from plots to Makie for printing the board
### see gist and video below
### can update plots based on where you click -- useful for highlighting possible moves

### https://gist.github.com/Datseris/4b9d25a3ddb3936d3b83d3037f8188dd
### https://www.youtube.com/watch?v=L-gyDvhjzGQ&t=377s


# Function to print board in repl
function print_board(board)
    for i in 1:BOARD_SIZE
        row = board[i, :]
        for j in 1:BOARD_SIZE
            if row[j] == OUTSIDE
                print(" ")
            else
                print(row[j])
            end
            print(" ")
        end
        println()
    end
    println()
end



### actually print board in nice way
### TODO add lines between squares
function PrintBoard(board,ranks=reverse(ranks), files=files)
    x=1:15
    y=1:15
    z = zeros(15,15)

    ### for board colours
    for i in x
        for j in y
            if iseven(i + j)
                z[i,j] = 1.0
            end
        end
    end

    ### remove outside board
    z[1,1:5] .= NaN
    z[1,11:15] .= NaN
    z[15,1:5] .= NaN
    z[15,11:15] .= NaN
    z[2,1:4] .= NaN
    z[2,12:15] .= NaN
    z[14,1:4] .= NaN
    z[14,12:15] .= NaN
    z[3,1:3] .= NaN
    z[3,13:15] .= NaN
    z[13,1:3] .= NaN
    z[13,13:15] .= NaN
    z[4,1:2] .= NaN
    z[4,14:15] .= NaN
    z[12,1:2] .= NaN
    z[12,14:15] .= NaN
    z[5,1:1] .= NaN
    z[5,15:15] .= NaN
    z[11,1:1] .= NaN
    z[11,15:15] .= NaN

    ### plot grid
    p1 = heatmap(x,y,z,cbar=false,xticks = (x,files),yticks = (y,ranks),colour=[:grey,:white],grid=false,size=(1000,1000));
    ### lines for edge of board
    plot!(p1,[0.5,5.5],[5.5,0.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,0.5],[5.5,10.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,5.5],[10.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[5.5,10.5],[15.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[5.5,10.5],[0.5,0.5],lw=1.5,colour=:black,label="")
    plot!(p1,[10.5,15.5],[0.5,5.5],lw=1.5,colour=:black,label="")
    plot!(p1,[15.5,15.5],[5.5,10.5],lw=1.5,colour=:black,label="")
    plot!(p1,[10.5,15.5],[15.5,10.5],lw=1.5,colour=:black,label="")

    ### vertical lines between squares
    plot!(p1,[1.5,1.5],[4.5,11.5],lw=1.5,colour=:black,label="")
    plot!(p1,[2.5,2.5],[3.5,12.5],lw=1.5,colour=:black,label="")
    plot!(p1,[3.5,3.5],[2.5,13.5],lw=1.5,colour=:black,label="")
    plot!(p1,[4.5,4.5],[1.5,14.5],lw=1.5,colour=:black,label="")
    plot!(p1,[5.5,5.5],[0.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[6.5,6.5],[0.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[7.5,7.5],[0.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[8.5,8.5],[0.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[9.5,9.5],[0.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[10.5,10.5],[0.5,15.5],lw=1.5,colour=:black,label="")
    plot!(p1,[11.5,11.5],[1.5,14.5],lw=1.5,colour=:black,label="")
    plot!(p1,[12.5,12.5],[2.5,13.5],lw=1.5,colour=:black,label="")
    plot!(p1,[13.5,13.5],[3.5,12.5],lw=1.5,colour=:black,label="")
    plot!(p1,[14.5,14.5],[4.5,11.5],lw=1.5,colour=:black,label="")

    ### horizontal lines between squares
    plot!(p1,[4.5,11.5],[1.5,1.5],lw=1.5,colour=:black,label="")
    plot!(p1,[3.5,12.5],[2.5,2.5],lw=1.5,colour=:black,label="")
    plot!(p1,[2.5,13.5],[3.5,3.5],lw=1.5,colour=:black,label="")
    plot!(p1,[1.5,14.5],[4.5,4.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,15.5],[5.5,5.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,15.5],[6.5,6.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,15.5],[7.5,7.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,15.5],[8.5,8.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,15.5],[9.5,9.5],lw=1.5,colour=:black,label="")
    plot!(p1,[0.5,15.5],[10.5,10.5],lw=1.5,colour=:black,label="")
    plot!(p1,[1.5,14.5],[11.5,11.5],lw=1.5,colour=:black,label="")
    plot!(p1,[2.5,13.5],[12.5,12.5],lw=1.5,colour=:black,label="")
    plot!(p1,[3.5,12.5],[13.5,13.5],lw=1.5,colour=:black,label="")
    plot!(p1,[4.5,11.5],[14.5,14.5],lw=1.5,colour=:black,label="")

    ### add pieces to board
    for column in 1:15
        row = reverse(board[:,column])
        for (idx,r) in enumerate(row)
            if r == 3
                annotate!(p1,column,[idx],"R")
            elseif r == 2
                annotate!(p1,column,[idx],"T")
            elseif r == 1
                annotate!(p1,column,[idx],"D")
            end
        end
    end
    # savefig(p1,"p1.png")

    display(p1)

end