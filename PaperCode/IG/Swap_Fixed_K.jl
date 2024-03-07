"""
The function find the best permutation obtained by swapping the kth job and its following jobs
in any possible positions of a sequence
"""

include("TWT.jl")
function Swap_Fixed_K(beta, d, sol, machine_sol, p, M, J, k)
    B_Float = ceil(length(sol) / M)
    B_2 = convert(Int, B_Float)
    improve = 0
    n = length(sol)
    zero_count = count(x -> x == 0, sol)
    New_sol = zeros(Int64,n,n-k+1)
    New_machine_sol = zeros(Int64,n,n-k+1)
    TWT_New_sol = zeros(n-k+1)

    if zero_count == 0
        for i in 1:n
            New_sol[i,1] = sol[i]
        end
    
        for i in 1:n
            New_machine_sol[i,1] = machine_sol[i]
        end
        tal_sol = []
        tal_sol = push!(New_sol[i,1])
        tal_sol = push!(New_machine_sol[i,1])
        TWT_New_sol[1] = TWT(beta, d, tal_sol, p, M, J)

        for j in 2:(n-k+1)
            # New_sol[:,j] = sol
            for i in 1:n
                New_sol[i,j] = sol[i]
            end
            t = New_sol[k,j]
            New_sol[k,j] = New_sol[k+j-1,j]
            New_sol[k+j-1,j] = t;

            for i in 1:n
                New_machine_sol[i,j] = machine_sol[i]
            end

            for b in 1:B_2
                for m in ((b-1)*M+1):(b*M)
                    for i in ((b-1)*M+1):(b*M)
                        while m != i
                            t = New_machine_sol[m,j]
                            New_machine_sol[m,j] = New_machine_sol[i,j]
                            New_machine_sol[i,j] = t;
                        end
                    end
                end
            end
            sol_sum = []
            sol_sum = push!(New_sol[:,j])
            sol_sum = push!(New_machine_sol[:,j])
            TWT_New_sol[j] = TWT(beta, d, sol_sum, p, M, J)
        end
    else 
       
        for i in 1:n
            New_sol[i,1] = sol[i]
        end
    
        for i in 1:n
            New_machine_sol[i,1] = machine_sol[i]
        end
        tal_sol = []
        tal_sol = push!(New_sol[i,1])
        tal_sol = push!(New_machine_sol[i,1])
        TWT_New_sol[1] = TWT(beta, d, tal_sol, p, M, J)

        sol_2 = filter(x -> x != 0, New_sol[i,1])
        
        for j in 2:(n-k+1-zero_count)
            # New_sol[:,j] = sol
            New_sol = zeros(Int64,n-zero_count,n-k+1-zero_count)
            for i in 1:(n-zero_count)
                New_sol[i,j] = sol_2[i]
            end
            t = New_sol[k,j]
            New_sol[k,j] = New_sol[k+j-1,j]
            New_sol[k+j-1,j] = t;
            last_indices = (n-zero_count): n
            for i in 1:zero_count
                insert_position = rand(last_indices)
                println("insert_position=",insert_position)
                insert!(New_sol[:,j], insert_position, 0)
            end

            for i in 1:n
                New_machine_sol[i,j] = machine_sol[i]
            end

            for b in 1:B_2
                for m in ((b-1)*M+1):(b*M)
                    for i in ((b-1)*M+1):(b*M)
                        while m != i
                            t = New_machine_sol[m,j]
                            New_machine_sol[m,j] = New_machine_sol[i,j]
                            New_machine_sol[i,j] = t;
                        end
                    end
                end
            end
            sol_sum = []
            sol_sum = push!(New_sol[:,j])
            sol_sum = push!(New_machine_sol[:,j])
            TWT_New_sol[j] = TWT(beta, d, sol_sum, p, M, J)
        end
    end
    TWT_Prime, best_prime_index = findmin(TWT_New_sol)
    sol_Prime = New_sol[:, best_prime_index]
    sol_machine_Prime = New_machine_sol[:, best_prime_index]

    if TWT_Prime < TWT_New_sol[1]
        improve = 1
    end

    return sol_Prime, sol_machine_Prime, TWT_Prime, improve

end