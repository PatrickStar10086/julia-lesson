using JLD, HDF5, LinearAlgebra, Random, CPUTime, JuMP, Gurobi



include("NEH_TWT.jl")
include("Neighbor_search.jl")
include("Destruction.jl")
include("Reconstruction.jl")
include("VNS.jl")

function HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)

    # d_pare, T_para and t_max are algorithms parameters
    n = J#问题（1）
    Temp = T_para*sum(p)/(10*9*n)

    # Initialize

    t0 = CPUtime_us()*10^(-6)
    println("t0 = ", t0)
    sol_0, TWT_sol_0 = NEH_TWT(beta,d, p, M, J)
    # println("The order sequence obtained by NEH is ", sol_0)
    # println("The best TWT value obtained by NEH is ", TWT_sol_0)
    sol_best = zeros(Int64,n)
    for i in 1:n    
        sol_best[i] = sol_0[i]
    end
    TWT_sol_best = TWT_sol_0

    # Local search
    sol_0, TWT_sol_0 = VNS(beta, d, sol_best, p, M, J)
    # sol_0, TWT_sol_0 = VNS(beta, d, sol_0, p, M, J)
    # println("The order sequence obtained by Local search is ", sol_0)
    # println("The best TWT value obtained by local search is ", TWT_sol_0)

    for i in 1:n
        sol_best[i] = sol_0[i]
    end
    TWT_sol_best = TWT_sol_0

    t1 = CPUtime_us()*10^(-6)-t0
    println("t1 = ", t1)


    while t1 < t_max
        sol_Prime = sol_0

        # Destruction
        sol_Prime,sol_R = IG_Destruction(d_para, sol_Prime)


        # Reconstruction
        sol_Prime, TWT_Prime = IG_Reconstruction(sol_Prime, sol_R, beta, d, p, M, J, d_para)
        # println("TWT_Prime = ", TWT_Prime)

        #Local search
        sol_Prime2, TWT_Prime2 = VNS(beta, d, sol_Prime, p, M, J)

        g = rand()
        # println("TWT_sol_0 = ", TWT_sol_0)
        # println("TWT_Prime2 = ", TWT_Prime2)
        sa = exp(-(TWT_sol_0-TWT_Prime2)/Temp)

        if TWT_Prime2 < TWT_sol_0
            for u in 1:n
                sol_0[u] = sol_Prime2[u]
            end
            TWT_sol_0 = TWT_Prime2
            if TWT_sol_0 < TWT_sol_best
                sol_best = sol_0
                TWT_sol_best = TWT_sol_0
                # println("TWT_sol_best = ", TWT_sol_best)
            end
        elseif g <= sa
            TWT_sol_0 = TWT_Prime2
        end
        t1 = CPUtime_us()*10^(-6)-t0
    end

    return sol_best, TWT_sol_best

end


# result = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
# println("sol_best, TWT_sol_best:",result)