
# The function runs local search based on insertion operations
include("insertion_Fixed_K.jl")
using Random

function IterativeImprovement_Insertion(beta, d, sol, p, M, J)

    n = length(sol)
    # println("n = ", n)
    u = randperm(n)
    improve = 1
    sol_Prime = zeros(n)
    sol_machine_Prime = zeros(Int64,n)
    TWT_Prime = 0
    while (improve == 1)
        improve = 0
        for i in 1:n
            k = u[i]
            sol_Prime, sol_machine_Prime, TWT_Prime, improve = Insertion_Fixed_K(beta, d, sol, p, M, J, k)
            # println("improve = ", improve)
            if improve == 1
                # for l in 1:n
                #     sol[l] = sol_Prime[l]
                # end
                sol = sol_Prime
            end
        end
    end

    return sol_Prime, sol_machine_Prime, TWT_Prime

end
