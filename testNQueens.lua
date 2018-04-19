NUM_Queens = 8   -- working on 8x8 chessboard

-- Loading NQueens library
dofile('NQueens.lua')

-- run the program
boardSolutions = addqueen({}, 1, NUM_Queens)
for i = 1, #boardSolutions do
    print(string.format('%dth board solution:\n===', i))
    printsolution(boardSolutions[i], NUM_Queens)
end
