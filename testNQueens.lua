NUM_Queens = 8   -- working on 8x8 chessboard

-- Loading NQueens library
dofile('NQueens.lua')

-- run the program

-- find and print the first solution
boardSolutions = addqueen_first({}, 1, NUM_Queens)
print("One of the eight-queens puzzle solutions is:")
printsolution(boardSolutions[1], NUM_Queens)

-- find the unique solutions
print('The unique solutions are:\n')
boardSolutions = find_funda_queens(NUM_Queens)
funda_BS = fundamental_boards(boardSolutions, NUM_Queens)
for i = 1, #funda_BS do
    printsolution(funda_BS[i], NUM_Queens)
end



