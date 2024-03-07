include("TWT.jl")

function IG_Reconstruction(sol_Prime, sol_R, beta, d, p, M, J, d_para)

    n = J
    n1 = n-d_para
    New_sol_Prime = zeros(n1)
    # for i in 1:n1
    #     New_sol_Prime[i] = sol_Prime[i]
    # end
    TWT_sol_Prime = 0

    for k in n1+1:n
        Seq = zeros(Int64,k,k)
        TWT_Seq = zeros(k)
        # println("k = ", k)
        for i in 1:k
            New_sol_Prime = zeros(Int64,length(sol_Prime))
            for u in 1:length(sol_Prime)
                New_sol_Prime[u] = sol_Prime[u]
            end
            # println("New_sol_Prime = ", New_sol_Prime)
            # println("sol_NEH = ", sol_NEH)
            Seq[:,i] = insert!(New_sol_Prime, i, sol_R[k-n1])
            # println("i = ", i)
            # println("Seq[:,i] = ", Seq[:,i])
            TWT_Seq[i] = TWT(beta, d, Seq[:,i], p, M, J)
        end
        TWT_sol_Prime,best_index = findmin(TWT_Seq)     # find the job index with the minimum TWT values
        sol_Prime = Seq[:,best_index]
        # TWT_sol_Prime = TWT_Seq[best_index]
    end

    # if TWT_prime >= TWT_sol_NEH
    #     TWT_sol_NEH = TWT_prime
    #     sol_NEH = sol_prime
    # end

    return sol_Prime, TWT_sol_Prime

end