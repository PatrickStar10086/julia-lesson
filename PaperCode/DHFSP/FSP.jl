using JuMP, Gurobi, Random

# 参数设定
n = 10 # 工件总数
m = 5 # 机器总数
low = 1 # 加工时间最小值
high = 99 # 加工时间最大值

# 生成随机数据
Random.seed!(1) # 设置随机种子
# t = rand(low:high, n, m) # 每个工件在每台机器上的加工时间

t = [[42 42 80 10 98]
    [72 68 96 42 75]
    [1 21 32 95 28]
    [30 87 69 53 79]
    [15 3 87 69 11]
    [10 67 89 32 45]
    [19 42 9 68 90]
    [35 56 4 83 30]
    [40 14 17 2 29]
    [54 20 87 75 13]] # 每个工件在每台机器上的加工时间

println(t)
# 创建模型
model = Model(Gurobi.Optimizer)

# 创建变量
@variable(model, x[1:n, 1:n], Bin)
@variable(model, C[1:n, 1:m] >= 0, Int)
@variable(model, makespan >= 0, Int)

# 设置目标函数
@objective(model, Min, makespan)

# 约束条件
@constraint(model, [i = 1:n], sum(x[i, :]) == 1)
@constraint(model, [k = 1:n], sum(x[:, k]) == 1)
@constraint(model, [i = 1:n], makespan >= C[i, m])
@constraint(model, C[1, 1] >= sum(x[i, 1] * t[i, 1] for i in 1:n))
@constraint(model, [k = 2:n, j = 1:m], C[k, j] >= C[k-1, j] + sum(x[i, k] * t[i, j] for i in 1:n))
@constraint(model, [k = 1:n, j = 2:m], C[k, j] >= C[k, j-1] + sum(x[i, k] * t[i, j] for i in 1:n))
@constraint(model, [k = 1:n, j = 1:m], C[k, j] >= 0)

# 设置求解器的最长运行时间为1小时（3600s）
set_optimizer_attribute(model, "TimeLimit", 3600)

# 模型求解
optimize!(model)

# 打印结果
if termination_status(model) == MOI.OPTIMAL
    println("最优解：")
    sequence = [findfirst(value.(x[i, :]) .> 0.5) for i in 1:n]
    for (i, k) in enumerate(sequence)
        println("$(i-1)是排列Π的第 $k 个工件")
    end
    println("工件的加工次序：", sequence)
    println("总完成时间：", objective_value(model))
elseif termination_status(model) == MOI.TIME_LIMIT
    println("目标函数值上界：", objective_value(model))
    println("目标函数值下界：", objective_bound(model))
else
    println("无可行解")
end