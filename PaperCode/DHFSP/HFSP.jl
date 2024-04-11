using JuMP, Random, Gurobi

# 创建模型
model = Model(Gurobi.Optimizer)

# 参数定义
N = 5  # 工件数
G = 2  # 加工阶段数量
Mmax = 3;
U = 1000;

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
println("p=", p)
# 创建模型
model = Model(Gurobi.Optimizer)

# 创建变量
@variable(model, X[1:N, 1:G, 1:Mmax], Bin) # 工件i在阶段g的机器m上加工，是为1，否为0
@variable(model, Y[1:N, 1:N, 1:G], Bin) # 工件i在阶段g在工件j之前加工，是为1，否为0
@variable(model, C[1:N, 1:G] >= 0, Int) # 工件i在阶段g的加工完成时间
@variable(model, B[1:N, 1:G] >= 0, Int) # 工件i在阶段g的加工开始时间
# @variable(model, Cf[1:N] >= 0, Int) # 工件i的加工完成时间
@variable(model, makespan >= 0, Int) # 最大完工时间

# 设置目标函数
@objective(model, Min, makespan)

# 约束条件
@constraint(model, [i in 1:N, g in 1:G], sum(X[i, g, m] for m in 1:M[g]) == 1) # 每个工件在每个阶段只能在一个机器上加工

@constraint(model, [i in 1:N], B[i, 1] >= 0) # 加工开始时间大于等于0
@constraint(model, [i in 1:N, g in 1:G-1], B[i, g+1] >= B[i, g] + p[i, g]) # 完工时间等于开始时间加工时间
@constraint(model, [i in 1:N, j in 1:N, g in 1:G], Y[i, j, g] + Y[j, i, g] <= 1) # 工件i与j的先后顺序
@constraint(model, [i in 1:N, j in 1:N, g in 1:G, m in 1:M[g]], B[i, g] - (B[j, g] + p[i, g]) + (U * (3 - Y[i, j, g] - X[i, g, m] - X[j, g, m])) >= 0) # 完工时间等于开始时间加工时间
@constraint(model, [i in 1:N, g in 1:G], C[i, g] == B[i, g] + p[i, g]) # 完工时间等于开始时间加工时间
@constraint(model, [i in 1:N, g in 1:G], makespan >= C[i, G])
# 设置求解器的最长运行时间为1小时（3600s）
set_optimizer_attribute(model, "TimeLimit", 3600)

# 模型求解
optimize!(model)

# 打印结果
println("最优解：", objective_value(model))

for i in 1:N
    for g in 1:G
        for m in 1:M[g]
            if value(X[i, g, m]) == 1
                println("工件$i 在阶段$g 的机器$m 上加工")
            end
        end
        println("加工开始时间 B[$i,$g]: ", value(B[i, g]))
        println("加工完成时间 C[$i,$g]: ", value(C[i, g]))
    end
end