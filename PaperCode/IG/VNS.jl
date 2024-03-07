
include("IterativeImprovement_Swap.jl")
include("IterativeImprovement_Insertion.jl")

function VNS(beta, d, sol, p, M, J)
    k = 1
    n = length(sol)
    TWT_sol = TWT(beta, d, sol, p, M, J)
    sol_Prime = zeros(n)
     TWT_Prime = 0
    while (k <= 2)
        if k == 1
            sol_Prime,  TWT_Prime = IterativeImprovement_Swap(beta, d, sol, p, M, J)
        else
            sol_Prime,  TWT_Prime = IterativeImprovement_Insertion(beta, d, sol, p, M, J)
        end

        if  TWT_Prime < TWT_sol
            sol = sol_Prime
            TWT_sol =  TWT_Prime
            # println("TWT_sol = ", TWT_sol)
            k = 1
        else
            k = k+1
        end
    end
    return sol, TWT_sol
end

