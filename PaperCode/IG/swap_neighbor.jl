include("TWT.jl")
function swap_neighbor(sol, beta, d, p, M, J)
    best_sol = copy(sol)
    best_twt = Inf

    for j in 1:J
        for other_j in 1:J
            if other_j != j
                new_sol = copy(sol)
                new_sol[j], new_sol[other_j] = new_sol[other_j], new_sol[j]
                twt = TWT(beta, d, new_sol, p, M, J)
                if twt < best_twt
                    best_sol = new_sol
                    best_twt = twt
                end
            end
        end
    end

    return best_sol, best_twt
end

