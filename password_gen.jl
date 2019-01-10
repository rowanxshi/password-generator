import StatsBase

function password_gen(p_length::Int = 16, included_types = [1, 2, 3, 4])
    letters = String["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    upper = map(uppercase, letters)
    numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    special = String["!", "@", "#", "%", "^", "&", "*", "?", "+"]

    # base of all possible characters
    all_char = [letters, upper, numbers, special][included_types]

    # determining the number of characters for each type:
    ## each gets at least 2
    n_char = 2*ones(Int, length(included_types))
    ## the rest apportioned based on relative number of possibilities
    extra_length = p_length - sum(n_char)
    proportions = extra_length*map(length, all_char)/sum(map(length, all_char))
    n_char = n_char + map(r -> floor(Int, r), proportions)
    ## account for rounding
    n_char[end] = p_length - sum(n_char[1:end-1])

    # draw the appropriate number of characters from each type
    p_chars = vcat(map((set, n_draw) -> StatsBase.sample(set, n_draw, replace=false), all_char, n_char)...)

    # arrange in random order, with letter as first character
    p_first = p_chars[1]
    p_index = StatsBase.sample(2:p_length, p_length-1, replace = false)

    p = *(p_first, p_chars[p_index]...)
end

p = password_gen()
clipboard(p)
