using JuMP, Gurobi, Random

# 参数设定
N = 10 # 工件总数
G = 3 # 加工阶段数量

MAX = 3
M[3] = [2, 2, 3]

low = 1 # 加工时间最小值
high = 99 # 加工时间最大值


# 生成随机数据
Random.seed!(1) # 设置随机种子
t = rand(low:high, N, G) # 每个工件在每个阶段上的加工时间


# 创建模型
model = Model(Gurobi.Optimizer)

# 创建变量
@variable(model, x[1:N, 1:G, 1:MAX], Bin) # 工件i在阶段g的机器m上加工，是为1，否为0
@variable(model, C[1:N, 1:G, 1:MAX] >= 0, Int) # 工件i在阶段g的机器m上的加工完成时间
@variable(model, B[1:N, 1:G, 1:MAX] >= 0, Int) # 工件i在阶段g的机器m上的加工开始时间
@variable(model, Cf[1:N] >= 0, Int) # 工件i的加工完成时间
@variable(model, makespan >= 0, Int) # 最大完工时间

# 设置目标函数
@objective(model, Min, makespan)

# 约束条件
@constraint(model, [i = 1:N], sum(x[i, :, :]) == 1) # 每个工件只能在一个阶段的一台机器上加工
@constraint(model, [m = 1:M[1]], C[1, 1, m] >= sum(x[i, 1, m] * t[i, 1] for i in 1:N))
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], makespan >= C[i, g, m])
@constraint(model, [g = 2:G, m = 1:MAX], C[1, g, m] >= C[1, g-1, m] + sum(x[i, g, m] * t[i, g] for i in 1:N))
@constraint(model, [g = 1:G, m = 2:MAX], C[1, g, m] >= C[1, g, m-1] + sum(x[i, g, m] * t[i, g] for i in 1:N))
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], C[i, g, m] >= B[i, g, m] + sum(x[i, g, m] * t[i, g] for i in 1:N))
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], B[i, g, m] >= Cf[i])
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], B[i, g, m] >= sum(x[j, g, m] * t[j, g] for j in 1:i))
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], Cf[i] >= C[i, g, m])
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], Cf[i] >= sum(x[j, g, m] * t[j, g] for j in 1:i))
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], C[i, g, m] >= 0)
@constraint(model, [i = 1:N, g = 1:G, m = 1:MAX], B[i, g, m] >= 0)

# 设置求解器的最长运行时间为1小时（3600s）
set_optimizer_attribute(model, "TimeLimit", 3600)

# 模型求解
optimize!(model)

# 打印结果
println("最优解：",objective_value(model))