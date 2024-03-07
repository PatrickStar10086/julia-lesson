using JuMP
using JLD, HDF5, LinearAlgebra, StatsBase

include("makespan.jl")

function TWT(beta, d, tal_sol, p, M, J)
    C,~ = makespan(tal_sol, p, M, J)
    T = zeros(Int64,J)

    for j in 1:J
        T[j] = C[j] -d[j] 
        if T[j] < 0
            T[j] = 0
        end
        # return T[j]   
    end   
    del_punish = sum(beta[j]*T[j] for j in 1:J)
    return del_punish
    # println(T)
    # println(beta)
    # println(Z)
end

# J = 10  # 工件数
# M = 5 # 机器数
# S = 3

# # 生成随机加工时间
# p=[81 44 20; 55 12 13; 32 33 56; 45 5 31; 71 85 9; 51 8 12; 49 63 42; 83 22 15; 93 88 34; 71 45 64]
# # 生成工件序列
# tal_sol = Any[[3, 2, 5, 10, 8, 4, 7, 6, 9, 1], [1, 3, 2, 4, 5, 2, 3, 4, 5, 1]]
# d=[90, 80, 179, 144, 107, 160, 198, 150, 161, 172]
# beta=[3, 2, 5, 1, 8, 1, 4, 3, 8, 10]
# del_punish = TWT(beta,d, tal_sol, p, M, J)
# println("del_punish =",del_punish)
# job_complete,MK = makespan(tal_sol, p, M, J)

# println("job_complete,MK: ", job_complete,MK)
# beta = [11, 13, 8, 27, 18, 30, 3, 1]
# d = [100, 200, 150, 200, 400, 370, 300, 350]
# # 设置参数
# J = 8  # 工件数
# M = 4  # 机器数
# S = 4

# # 生成随机加工时间
# p = rand(1:100, J, S)
# println(p)

# # 生成工件序列
p=[27 95 74; 90 12 94; 37 40 80; 28 81 90; 45 38 87; 100 19 15; 40 11 14; 98 4 75; 40 66 23; 67 98 44]
# sol = [1, 4, 7, 2, 5, 8, 3, 6]
# del_punish = TWT(beta,d,sol, p, M, J)
# println("del_punish = $del_punish")
beta = [11, 13, 8, 27, 18, 30, 3, 1, 15, 17]
d = [100, 200, 150, 200, 400, 370, 300, 350, 260, 410]
# 设置参数
J = 10  # 工件数
M = 4# 机器数
S = 3
tal_sol = Any[[7, 8, 3, 5, 4, 1, 9, 6, 0, 2, 10, 0], [2, 3, 4, 1, 2, 4, 3, 1, 3, 2, 1, 4]]
del_punish = TWT(beta,d,tal_sol, p, M, J)
println("del_punish=", del_punish)