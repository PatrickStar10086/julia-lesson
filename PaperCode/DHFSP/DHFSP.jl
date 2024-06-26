using JuMP, Random, Gurobi

# 创建模型
model = Model(Gurobi.Optimizer)

# 参数定义
F = 2  # 工厂数
N = 7  # 工件数
G = 2  # 加工阶段数量
Mmax = 2;


# 设置随机数生成器的种子，以确保结果可重复
Random.seed!(12)

# 每个加工阶段的并行机器数量
M = Array{Int}(undef, G)
for i in 1:G
    # M[i] = rand(1:Mmax)
    M[i] = 2
end
println("M = ", M)
# 工序i在工件j车间g的机器k上的加工时间

# 工件在加工阶段的每个并行机器上加工时间都相同
p = Array{Int}(undef, N, G)
for i in 1:N
    for g in 1:G
        p[i, g] = rand(10:80)
    end
end
# 工件在加工阶段的每个并行机器上加工时间都不同
# p = Array{Int}(undef, N, F, G, M)
# for i in 1:N
#     for f in 1:F
#         for g in 1:G
#             for k in 1:M[g]
#                 p[i, f, g, k] = rand(10:80)
#             end
#         end
#     end
# end

println("p = ", p);

H = 1000  # 一个足够大的数


# 决策变量
@variable(model, X[1:N, 1:F] >= 0, Bin) # 工件i是否在工厂f加工，是为1，否为0
@variable(model, Y[1:N, 1:F, 1:G, 1:Mmax] >= 0, Bin) # 工件i在阶段g的机器k上加工，是为1，否为0
@variable(model, Z[1:N, 1:N, 1:F, 1:G, 1:Mmax] >= 0, Bin) # 工序j是否先于工件i在工厂f的车间g的机器m上加工，是为1，否为0
@variable(model, Z1[1:N, 1:N] >= 0, Bin) # 工件的加工的顺序判断
# 变量
@variable(model, B[1:N, 1:G] >= 0, Int) # 工件i在车间g的加工开始时间
@variable(model, C[1:N, 1:G] >= 0, Int) # 工件i在车间g的加工完成时间
@variable(model, Cmax >= 0, Int) # 最大完工时间


# 目标函数 
@objective(model, Min, Cmax) # 最小化最大完工时间

# 约束
@constraint(model, [i in 1:N], sum(X[i, f] for f in 1:F) == 1) # 每个工件只能在一个工厂加工
# @constraint(model, [i in 1:N, f in 1:F, g in 1:G], Z[])
@constraint(model, [i in 1:N, f in 1:F, g in 1:G], sum(Y[i, f, g, m] for m in 1:M[g]) == X[i, f]) # 如果工件i在工厂f加工，则工件i在工厂f的车间g的机器k上加工
# @constraint(model, [i in 1:N, f in 1:F], sum(Y[i, f, g, m] for g in 1:G for m in M[g]) == X[i, f]) # 如果工件i在工厂f加工，则工件i在工厂f的车间g的机器k上加工

@constraint(model, [i in 1:N, j in 1:N, f in 1:F, g in 1:G, m in 1:M[g]], Z[i, j, f, g, m] + Z[j, i, f, g, m] <= 1) # 工序i和工件j只能有一个先于另一个在工厂f的车间g的机器m上加工
@constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], C[i, g] >= C[j, g] + p[i, g] - (3 - Z[i, j, f, g, m] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序j先于工件i在工厂f的车间g的机器m上加工，则工件i在车间g的加工完成时间大于等于工件j在车间g的加工完成时间+加工时间
@constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], C[j, g] >= C[i, g] + p[j, g] - (2 + Z[i, j, f, g, m] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序i先于工件j在工厂f的车间g的机器m上加工，则工件j在车间g的加工完成时间大于等于工件i在车间g的加工完成时间+加工时间
@constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], B[i, g] >= C[j, g] - (3 - Z[i, j, f, g, m] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序j先于工件i在工厂f的车间g的机器m上加工，则工件i在车间g的加工完成时间大于等于工件j在车间g的加工完成时间+加工时间
@constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], B[j, g] >= C[i, g] - (2 + Z[i, j, f, g, m] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序i先于工件j在工厂f的车间g的机器m上加工，则工件j在车间g的加工完成时间大于等于工件i在车间g的加工完成时间+加工时间

# @constraint(model, [i in 1:N-1, j in i+1:N], Z1[i, j] + Z1[j, i] <= 1) # 工序i和工件j只能有一个先于另一个在工厂f的车间g的机器m上加工
# @constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], C[i, g] >= C[j, g] + p[i, g] - (3 - Z1[i, j] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序j先于工件i在工厂f的车间g的机器m上加工，则工件i在车间g的加工完成时间大于等于工件j在车间g的加工完成时间+加工时间
# @constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], C[j, g] >= C[i, g] + p[j, g] - (2 + Z1[i, j] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序i先于工件j在工厂f的车间g的机器m上加工，则工件j在车间g的加工完成时间大于等于工件i在车间g的加工完成时间+加工时间
# @constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], B[i, g] >= C[j, g] - (3 - Z1[i, j] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序j先于工件i在工厂f的车间g的机器m上加工，则工件i在车间g的加工完成时间大于等于工件j在车间g的加工完成时间+加工时间
# @constraint(model, [i in 1:N-1, j in i+1:N, f in 1:F, g in 1:G, m in 1:M[g]], B[j, g] >= C[i, g] - (2 + Z1[i, j] - Y[i, f, g, m] - Y[j, f, g, m]) * H) # 若工序i先于工件j在工厂f的车间g的机器m上加工，则工件j在车间g的加工完成时间大于等于工件i在车间g的加工完成时间+加工时间

@constraint(model, [i in 1:N, g in 2:G], B[i, g] >= C[i, g-1]) # 工件i在车间g的加工开始时间大于等于工件i在车间g-1的加工完成时间
@constraint(model, [i in 1:N, g in 1:G], C[i, g] >= B[i, g] + p[i, g]) #如果工件在g阶段加工，则工件i在阶段g的加工完成时间必须大于等于工件i在阶段g的开始时间+加工时间
@constraint(model, [i in 1:N], Cmax >= C[i, G]) # 工件i的加工完成时间等于工件i在车间m的加工完成时间

# 求解优化问题
JuMP.set_time_limit_sec(model, 3600)  # 设置时间限制
JuMP.optimize!(model)    #求解模型

println("最大完工时间: ", value(Cmax))

# println("x: ", X)
# println("y: ", value.(Y))
# println("====================================================")
# for i in 1:N
#     for j in 1:N
#         for f in 1:F
#             for g in 1:G
#                 for m in 1:M[g]
#                     if value(Y[i, f, g, m]) == 1 && value(Y[j, f, g, m]) == 1 && i < j
#                         println("Y[$i,$f,$g,$m]: ", value(Y[i, f, g, m]))
#                         println("工件 $i 和工件 $j 在工厂 $f 的车间 $g 的机器 $m 上加工")
#                     end
#                     if value(Z1[i, j]) == 1 && value(Y[i, f, g, m]) == 1 && value(Y[j, f, g, m]) == 1
#                         println("Z1[$i,$j]: ", value(Z1[i, j]))
#                         println("工件 $j 先于工件 $i 在工厂 $f 的车间 $g 的机器 $m 上加工")
#                     end
#                 end
#             end
#         end
#     end
# end

# println("====================================================")



for i in 1:N
    for f in 1:F
        if value(X[i, f]) == 1
            println("工件 $i 在工厂 $f 加工---------------------------------------------------------")
            for g in 1:G
                # for j in 1:N
                #     if value(X[j, f]) == 1
                #         for m in 1:M[g]
                #             if value(Z[i, j, f, g, m]) == 1
                #                 println("Z[$i,$j,$f,$g,$m]: ", value(Z[i, j, f, g, m]))
                #                 println("工件 $i 先于工件 $j 在工厂 $f 的车间 $g 的机器 $m 上加工")
                #             end
                #         end
                #     end
                # end
                for m in 1:M[g]
                    if value(Y[i,f,g,m]) == 1
                        println("工件 $i 在工厂 $f 的 车间 $g 的 $m 机器上加工")
                    end
                end

                println("加工开始时间 B[$i,$g]: ", value(B[i, g]))
                println("加工完成时间 C[$i,$g]: ", value(C[i, g]))
            end
        end
    end
end