using JuMP, Random, Gurobi

# 创建模型
model = Model(Gurobi.Optimizer)

# 参数定义
F = 2  # 工厂数
N = 10  # 工件数
G = 2  # 加工阶段数量
Mmax = 2;


# 设置随机数生成器的种子，以确保结果可重复
Random.seed!(12)

# 每个加工阶段的并行机器数量
M = Array{Int}(undef, G)
for i in 1:G
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
@variable(model, Y[1:N, 1:G, 1:Mmax] >= 0, Bin) # 工件i在阶段g的机器k上加工，是为1，否为0
@variable(model, Z[1:N, 1:N, 1:G] >= 0, Bin) # 工序j是否先于工件i在工厂f的车间g的机器m上加工，是为1，否为0
@variable(model, W[1:N, 1:N, 1:G] >= 0, Bin) # 工件的加工的顺序判断
# 变量
@variable(model, B[1:N, 1:G] >= 0, Int) # 工件i在车间g的加工开始时间
@variable(model, C[1:N, 1:G] >= 0, Int) # 工件i在车间g的加工完成时间
@variable(model, Cmax >= 0, Int) # 最大完工时间


# 目标函数 
@objective(model, Min, Cmax) # 最小化最大完工时间

# 约束
@constraint(model, [i in 1:N], sum(X[i, f] for f in 1:F) == 1) # 每个工件只能在一个工厂加工
@constraint(model, [i in 1:N, f in 1:F], sum(Y[i, g, m] for g in G for m in M[g]) == 1) # 如果工件i在工厂f加工，则工件i在工厂f的车间g的机器k上加工
@constraint(model, [i in 1:N, g1 in G, g2 in G, m in M[g1]], B[i, g1] + p[i, g1] + H * (1 - Z[i, i, g2]) <= B[i, g2]) # 工序j是否先于工件i在工厂f的车间g的机器m上加工


# 求解优化问题
JuMP.set_time_limit_sec(model, 3600)  # 设置时间限制
JuMP.optimize!(model)    #求解模型

println("最大完工时间: ", value(Cmax))