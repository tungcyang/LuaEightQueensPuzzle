--[[
NQueens.lua implements a few functions handy for the N-Queens puzzle.
(Eight queens puzzle, in https://en.wikipedia.org/wiki/Eight_queens_puzzle)

We will describe the NxN chessboard by rows.  Row 1 is on the top, Row 2 is immediately beneath it,
and so on, until the bottom Row N.  Column 1 is the leftmost column, etc.
]]


-- isplaceok() returns true if it is okay to put a queen in Row 'n' at Column 'c' in the chessboard 'a'
function isplaceok(a, n, c, N)
    for i = 1, n-1 do
        if a[i] == c then
            -- the queen on Row 'i' and the one on Row 'n' are both on Column 'c' and they
            -- attack each other
            return false
        elseif (i + a[i]) == (n + c) then
            -- the queen on Row 'i' and the one on Row 'n' are both on the same diagonal
            -- from upper right to lower left and they attack each other
            return false
        elseif (i - a[i]) == (n - c) then
            -- the queen on Row 'i' and the one on Row 'n' are both on the same diagonal
            -- from upper left to lower right and they attack each other
            return false
        end
    end
    -- we are safe and there is no attack among the queens up to Row 'n'.
    return true
end


-- printsolution() prints out the queens on the chessboard 'a'
function printsolution(a, N)
    for i = 1, N do
        for j = 1, N do
            -- printing 'X' for the queen, or '-' otherwise
            io.write((a[i] == j) and 'X' or '-', ' ')
        end
        io.write('\n')
    end
    io.write('\n')
end


-- addqueen() attempts to add queens from Row 'n' up to 'N' on the chessboard 'a'
-- while avoiding introducing attacking or attacked queens.  It returns a table of
-- good queen configuration on the chessboard, or {} otherwise.
function addqueen(a, n, N)
    local goodChessboards = {}

    for c = 1, N do
        if isplaceok(a, n, c, N) then
            a[n] = c
            if (n == N) then
                -- We found a valid square to put the queen and it is the bottom row.
                -- No need to try the next 'c's.

                -- Making a deep copy of a before returning.
                local res = {}
                for k, v in pairs(a) do
                    res[k] = v
                end
                return {res}
            else
                -- We found a valid square but we are not done yet.
                local aNext = addqueen(a, n+1, N)
                -- appending aNext to goodChessboards
                for i = 1, #aNext do
                    table.insert(goodChessboards, aNext[i])
                end
            end
        end
    end

    -- We looped around for all possible c's and we cannot find a successful queen position.
    return goodChessboards
end
