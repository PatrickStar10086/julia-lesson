include("Swap_Fixed_K.jl")
function IterativeImprovement_Swap(beta, d, tal_sol, p, M, J)
    improve = 1
    sol = copy(tal_sol[1])
    machine_sol = copy(tal_sol[2])
    n = length(sol)
    sol_Prime = zeros(Int64,n)
    TWT_Prime = 0
    while (improve == 1)
        improve = 0
        for k in 1:n-1
            sol_Prime, sol_machine_Prime, TWT_Prime, improve = Swap_Fixed_K(beta, d, sol, machine_sol, p, M, J, k)
            if improve == 1
                for i in 1:n
                    sol[i] = sol_Prime[i]
                    machine_sol[i] = sol_machine_Prime[i]
                end
            end
        end
    end
    return sol_Prime, sol_machine_Prime, TWT_Prime
end
