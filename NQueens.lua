--[[
NQueens.lua implements a few functions handy for the N-Queens puzzle.
(Eight queens puzzle, in https://en.wikipedia.org/wiki/Eight_queens_puzzle)
We will describe the NxN chessboard by rows.  Row 1 is on the top, Row 2 is immediately beneath it,
and so on, until the bottom Row N.  Column 1 is the leftmost column, etc.
]]

local p = require('permutation')

-- isplaceok() returns true if it is okay to put a queen in Row 'n' at Column 'c' in the chessboard 'a'
function isplaceok(a, n, c, N)
    local i

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
    local i, j

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
    local c

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


-- addqueen_first() does the same as addqueen() except that it stops and returns upon the
-- discovery of the first solution.
function addqueen_first(a, n, N)
    local c

    for c = 1, N do
        if isplaceok(a, n, c, N) then
            a[n] = c
            if (n == N) then
                -- We found a valid square to put the queen and it is the bottom row.
                -- No need to try the next 'c's.

                -- Unlike addqueen(), there is no need to modify a further, so we don't
                -- need a hardcopy and we can return {a}.
                return {a}
            else
                local aNext = addqueen_first(a, n+1, N)

                -- We found a valid square and we are done.
                if #aNext > 0 then
                    return aNext
                end
            end
        end
    end

    -- We looped around for all possible c's and we cannot find a successful queen position.
    return {}
end


-- mirror() returns a mirror image of the NxN chessboard 'a' so the left and right sides are
-- reverted.
function mirror(a, N)
    local mirrora = {}
    local c

    for c = 1, N do
        -- In row c if we have a queen in column a[c], then there will be a corresponding
        -- queen in row c and column N - a[c] + 1 in the mirrored a.
        mirrora[c] = N - a[c] + 1
    end

    return mirrora
end


-- rotate() returns a rotated image of the NxN chessboard 'a' (clockwise by 90 degrees)
function rotate(a, N)
    local rotateda = {}
    local c

    for c = 1, N do
        -- In row c if we have a queen in column a[c], then there will be a corresponding
        -- queen in row a[c] and column N - c + 1 in the rotated a.
        rotateda[a[c]] = N - c + 1
    end

    return rotateda
end


-- generate_equivalent_boards() returns 8 NxN chessboards which is "equivalent" to the input
-- a as they are either mirrored or rotated versions of a.
function generate_equivalent_boards(a, N)
    local equivalent_boards = {}
    local transformed_a = rotate(a, N)

    table.insert(equivalent_boards, transformed_a)
    transformed_a = rotate(transformed_a, N)
    table.insert(equivalent_boards, transformed_a)
    transformed_a = rotate(transformed_a, N)
    table.insert(equivalent_boards, transformed_a)
    transformed_a = rotate(transformed_a, N)
    table.insert(equivalent_boards, transformed_a)
    
    -- Now rotated_a should be the same as a (it has been rotated by 90 degrees four times)
    transformed_a = mirror(transformed_a, N)

    table.insert(equivalent_boards, transformed_a)
    transformed_a = rotate(transformed_a, N)
    table.insert(equivalent_boards, transformed_a)
    transformed_a = rotate(transformed_a, N)
    table.insert(equivalent_boards, transformed_a)
    transformed_a = rotate(transformed_a, N)
    table.insert(equivalent_boards, transformed_a)

    return equivalent_boards
end


-- board_equal() compares two NxN chessboards and see if they are equal.
function board_equal(a, b, N)
    local i

    for i = 1, N do
        if a[i] ~= b[i] then
            return false
        end
    end

    return true
end


-- Given a list of NxN chessboards bs, fundamental_boards() returns another list of chessboards
-- which contains all boards in bs but without their duplicates (mirrored or rotated versions).
function fundamental_boards(bs, N)
    local funda_bs = {}
    local funda_bsx8 = {}
    local i, j

    for i = 1, #bs do
        -- We want to check if bs[i] is equal to one of the boards in funda_bsx8.  Because there
        -- are more chessboards we found than their "fundamental" versions, it should be more efficient
        -- to generate the 8 transformed copies of the fundamental versions to check against than
        -- generate the 8 transformed copies of the solutions we found.
        local found_in_funda_bsx8 = false

        for j = 1, #funda_bsx8 do
            if board_equal(bs[i], funda_bsx8[j], N) then
                found_in_funda_bsx8 = true
                break
            end
        end

        -- Need to handle the case when bs[i] is not equal to any of the boards in
        -- funda_bsx8.
        if not found_in_funda_bsx8 then
            -- Include bs[i] in funda_bs
            table.insert(funda_bs, bs[i])

            local transformedbsi = generate_equivalent_boards(bs[i], N)
            for j = 1, #transformedbsi do
                table.insert(funda_bsx8, transformedbsi[j])
            end
        end
    end

    return funda_bs
end


-- find_funda_queens() finds all the fundamental solutions for the N-queen puzzle.  Unlike
-- addqueen() or addqueen_first(), it uses permutation of the indices to derive chessboards
-- and then see if the permuted indices correspond to a chessboard where no queens attack each
-- other.
function find_funda_queens(N)
    local res = {}
    local s = {}
    local i

    -- initialzing the increasing sequence s.
    for i = 1, N do
        s[i] = i
    end
    -- sequence s means we have a queen in column s[i] on row i.

    -- Generating all permutations of s
    while s do
        -- Check if s can represent a valid chessboard where queens do not attack each other.
        -- By the design of permutations, it is already ensured no queens are on the same row
        -- nor on the same column.  We only need to check if the queens attack each other
        -- diagonally.
        local sum_sii = {}
        local diff_sii = {}
        local diagonal_attack = false

        for i = 1, N do
            if sum_sii[i + s[i]] then
                -- two i's lead to the same i + s[i], so the corresponding queens attack
                -- each other.
                diagonal_attack = true
                break
            else
                sum_sii[i + s[i]] = true
            end
            if diff_sii[i - s[i]] then
                -- two i's lead to the same i - s[i], so the corresponding queens attack
                -- each other.
                diagonal_attack = true
                break
            else
                diff_sii[i - s[i]] = true
            end
        end

        if not diagonal_attack then
            table.insert(res, s)
        end

        -- permute to get the next s.
        s = p.lexi_permute(s)
    end

    return res
end