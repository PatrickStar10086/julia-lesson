"""

The function finds the best permutation sequence by inserting order k in any position of a sequence

"""

include("NEH_TWT.jl")

function Insertion_Fixed_K(beta, d, sol, machine_sol, p, M, J, k)
    B_Float = ceil(length(sol) / M)
    B_2 = convert(Int, B_Float)
    improve = 0
    n = length(sol)
    zero_count = count(x -> x == 0, sol)
    New_sol = zeros(Int64, n, n) # New_sol is a matrix composed by n sequences
    New_machine_sol = zeros(Int64,n, n)
    m = findfirst(isequal(k), sol) # find the position of order k in sequence sol     
    
    if zero_count == 0
        if m == 1
            New_sol[:,1] = sol
            for i in 2:n
                New_sol[:,i] = sol
                New_sol[1:i-1,i] = sol[2:i]
                New_sol[i,i] = sol[1]
            end
        elseif m == n
            New_sol[:,n] = sol
            for i in 1:n-1
                New_sol[:,i] = sol
                New_sol[i+1:n,i] = sol[i:n-1]
                New_sol[i,i] = sol[n]
            end
        else
            New_sol[:,m] = sol
            for i in 1:m-1
                New_sol[:,i] = sol
                New_sol[i+1:m,i] = sol[i:m-1]
                New_sol[i,i] = sol[m]
            end
            for i = m+1:n
                New_sol[:,i] = sol
                New_sol[m:i-1,i] = sol[m+1:i]
                New_sol[i,i] = sol[m]
            end
        end

        for i in 1:n
            New_machine_sol[i,j] = machine_sol[i]
        end

        for b in 1:B_2
            for m in ((b-1)*M+1):(b*M)
                removed = filter(x -> x != m, New_machine_sol[:,m])
                for i in ((b-1)*M+1):(b*M)
                    New_machine_sol[:,m] = insert!(copy(removed), i, m)
                end
            end
        end

        for j in 1:n
            sol_sum = []
            sol_sum = push!(New_sol[:,j])
            sol_sum = push!(New_machine_sol[:,j])
            TWT_Vector[j] = TWT(beta, d, sol_sum, p, M, J)
        end

        TWT_Prime, best_sol_prime = findmin(TWT_Vector)
        sol_Prime = New_sol[:,best_sol_prime]
        sol_machine_Prime = New_machine_sol[:,best_sol_prime]

        if TWT_Prime < TWT_Vector[m]
            improve = 1
        end

    else
        sol_2 = filter(x -> x != 0, New_sol[i,1])
        New_sol = zeros(Int64,n-zero_count,n-zero_count)
        for i in 1:(n-zero_count)
            New_sol[i,j] = sol_2[i]
        end
        removed = filter(x -> x != m, New_sol[:,m])
        for i in 1:length(removed)+1
            New_sol[:,m] = insert!(copy(removed), i, m)
        end
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
                removed = filter(x -> x != m, New_machine_sol[:,m])
                for i in ((b-1)*M+1):(b*M)
                    New_machine_sol[:,m] = insert!(copy(removed), i, m)
                end
            end
        end

        for j in 1:n
            sol_sum = []
            sol_sum = push!(New_sol[:,j])
            sol_sum = push!(New_machine_sol[:,j])
            TWT_Vector[j] = TWT(beta, d, sol_sum, p, M, J)
        end

        TWT_Prime, best_sol_prime = findmin(TWT_Vector)
        sol_Prime = New_sol[:,best_sol_prime]
        sol_machine_Prime = New_machine_sol[:,best_sol_prime]

        if TWT_Prime < TWT_Vector[m]
            improve = 1
        end

    return sol_Prime, sol_machine_Prime, TWT_Prime, improve

    end
end