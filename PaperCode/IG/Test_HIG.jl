"""

The code tests function hybrid iterated greedy algorithms (HIG_Insert, HIG_Swap, HIG_VNS)

"""

"""

The code tests the TWT_NEH

"""

using JLD, HDF5, LinearAlgebra, Random, CPUTime, JuMP, Gurobi

# filenm = "C:/Users/刘延硕/Desktop/IG/Ins_10_5_0.4_0.6_1.jld"
# filenm ="C:/Users/刘延硕/Desktop/IG/Ins_50_10_0.4_0.6_3.jld"
# filenm = "C:/Users/刘延硕/Desktop/初始模型/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/Data/Ins_6_3_0.4_0.6_2.jld"  
# filenm = "C:/Users/刘延硕/Desktop/初始模型/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/Data/Ins_6_3_0.4_0.6_2.jld" 
# filenm ="C:/Users/刘延硕/Desktop/IG/Ins_10_5_0.4_0.6_2.jld"
# filenm ="C:/Users/刘延硕/Desktop/Data/Ins_100_10_0.4_0.6_1.jld"
# filenm ="C:/Users/刘延硕/Desktop/IG/Ins_10_5_0.4_0.6_2.jld"
# filenm ="C:/Users/刘延硕/Desktop/IG/Ins_50_10_0.4_0.6_3.jld"
# filenm = "C:/Users/刘延硕/Desktop/初始模型/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/Data/Ins_6_3_0.4_0.6_1.jld"
# filenm = "C:/Users/刘延硕/Desktop/初始模型/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/IPMSP_CSSC_TWT_Julia(To LiuYanshuo)/Data/Ins_6_3_0.4_0.6_2.jld"
# filenm ="C:/Users/刘延硕/Desktop/IG/Ins_10_5_0.4_0.6_1.jld"
# filenm = "C:/Users/刘延硕/Desktop/IG/Ins_10_5_0.4_0.6_2.jld"

# J = load(filenm,"JJ")     # Number of orders

# # println("J :",J )

# M = load(filenm,"MM")     # Number of machines
# # println("M :",M )

# p = load(filenm,"pp")     # Processing times
# # println("P :",p )

# d = load(filenm, "dd")
# # println("d :",d )

# beta = load(filenm, "betabeta")
# println("beta :",beta )

# # Set parameters for algorithms
# d_para = 4
# T_para = 0.4
# t_max = 0.02*J*M

include("NEH_TWT.jl")
include("Neighbor_search.jl")
include("Destruction.jl")
include("Reconstruction.jl")
include("VNS.jl")
include("HIG_VNS.jl")
include("makespan.jl")


# sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
# c_k = makespan(sol_best, p, M, J)
# println("complet_job:",c_k[1])
# println("makespan:",c_k[2])
# println("sol_best = ", sol_best)
# println("TWT_sol_best = ", TWT_sol_best)
# # TWT_best = TWT(beta, d, sol_best, p, M, J)
# # println("x_best = ", TWT_best )

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_20_5_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("20_5",i,"次")
# end

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_20_10_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("20_10",i,"次")
# end

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_30_10_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("30_10",i,"次")
# end

for i in 1:2
    
    filenm = "C:/Users/刘延硕/Desktop/模型调试/3stage model/Ins_10_5_0.4_0.6_1.jld"  
    J = load(filenm,"JJ")     # Number of orders
    M = load(filenm,"MM")     # Number of machines
    p = load(filenm,"pp") 
    println("p=",p)    # Processing times
    d = load(filenm, "dd")
    println("d=",d)
    beta = load(filenm, "betabeta")
    println("beta=",beta)

    d_para = 3
    T_para = 0.4
    t_max = 4*J*M
    sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
    c_k = makespan(sol_best, p, M, J)
    # println("complet_job:",c_k[1])
    println("makespan:",c_k[2])
    # println("sol_best = ", sol_best)
    println("TWT_sol_best = ", TWT_sol_best)
    # TWT_best = TWT(beta, d, sol_best, p, M, J)
    # println("x_best = ", TWT_best )
    println("6_3",i,"次")
end


# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_70_20_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("70_20",i,"次")
# end

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_50_10_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("50_10",i,"次")
# end

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_50_20_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("50_20",i,"次")
# end

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_50_25_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("50_25",i,"次")
# end


# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_100_10_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("100_10",i,"次")
# end

# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_100_20_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("100_20",i,"次")
# end


# for i in 1:10
#     filenm ="C:/Users/刘延硕/Desktop/Data/Ins_100_25_0.4_0.6_1.jld"
#     J = load(filenm,"JJ")     # Number of orders
#     M = load(filenm,"MM")     # Number of machines
#     p = load(filenm,"pp")     # Processing times
#     d = load(filenm, "dd")
#     beta = load(filenm, "betabeta")

#     d_para = 3
#     T_para = 0.4
#     t_max = 0.05*J*M
#     sol_best, TWT_sol_best = HIG_VNS(d_para, T_para, t_max, beta, d, p, M, J)
#     c_k = makespan(sol_best, p, M, J)
#     # println("complet_job:",c_k[1])
#     println("makespan:",c_k[2])
#     # println("sol_best = ", sol_best)
#     println("TWT_sol_best = ", TWT_sol_best)
#     # TWT_best = TWT(beta, d, sol_best, p, M, J)
#     # println("x_best = ", TWT_best )
#     println("100_25",i,"次")
# end

