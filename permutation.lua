--[[
permutation.lua implements the scheme by Narayana Pandita to generate permutations in lexicographic
order (https://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order).  The user is
supposed to call lexi_permute() first with a (weakly) increasing sequence so lexi_permute() will
generate all the permutations before returning nil.

permutation.lua is implemented as a Lua module.
]]

local P = {}

-- lexi_permute() returns the next permuntation of s according to Narayana's algorithm.  It assumes
-- sequence s is an array-like Lua table.
function P.lexi_permute(s)
    local next_s = {}
    local i, m, k

    -- 1. Making a copy of s into next_s, and at the same time find the largest index k such that
    --    s[k] < s[k + 1].  If no such index k exists, s is the last permutation.
    for i = 1, #s do
        next_s[i] = s[i]
        -- k = (s[i] < s[i+1]) ? i : k, in case s[i+1] is not nil
        k = (s[i+1] and (s[i] < s[i+1])) and i or k
    end
    if not k then
        return nil
    end

    -- 2. Find the largest index m greater than k such that s[k] < s[m].  Because of 1., m is at least
    --    (k + 1).
    for i = (k + 1), #next_s do
        m = (next_s[k] < next_s[i]) and i or m
    end

    -- 3. Swap the value of s[k] with that of s[m].
    i = next_s[k]
    next_s[k] = next_s[m]
    next_s[m] = i

    -- 4. Reverse the sequence from s[k+1] up to and including the final element.
    i = k + 1
    m = #next_s
    while i < m do
        k = next_s[i]
        next_s[i] = next_s[m]
        next_s[m] = k
        i = i + 1
        m = m - 1
    end

    -- We are done with Narayana's method.
    return next_s
end


function P.prints(s)
    str = ''

    for i = 1, #s do
        str = str .. ' ' .. s[i]
    end

    print(str)
end


return P