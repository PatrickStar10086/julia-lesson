using JuMP
using Gurobi
using Random
# 参数设定
n = 7 # 工件总数 i
m = 2 # 机器总数 j
F = 2 # 工厂总数 f 
K = 7 # 工件位置 k
M = 1000 # 足够大的数
low = 1 # 加工时间最小值
high = 30 # 加工时间最大值

# 生成随机数据
Random.seed!(32) # 设置随机种子
p = rand(low:high, F, n, m) #工厂f上的工件i在机器j上的加工时间

print("P:",p)
# 创建模型
model = Model(Gurobi.Optimizer)

# 创建变量
@variable(model, x[1:F, 1:n]) #工件分配给工厂
@variable(model, y[1:F, 1:n, 1:K, 1:m], Bin) #工厂f中机器j上工件i在位置k加工，为1，否则为0
@variable(model, C[1:F, 1:K, 1:m] >= 0, Int) #被分配至工厂f的第k个位置上的工件在机器j上的完工时间
@variable(model, Cmax >= 0, Int) #最大完工时间

#设置目标函数
@objective(model, Min, Cmax)

# 约束条件
@constraint(model, [i = 1:n], sum(x[f, i] for f in 1:F) == 1)
@constraint(model, [f = 1:F], C[f, 1, 1] >= sum(y[f, i, 1, 1] * p[f, i, 1] for i in 1:n))
@constraint(model, [j = 2:m, f = 1:F], C[f, 1, j] >= C[f, 1, j-1] + sum(y[f, i, 1, j] * p[f, i, j] for i in 1:n))
@constraint(model, [j = 1:m, f = 1:F, k = 2:K], C[f, k, j] >= C[f, k-1, j] + sum(y[f, i, k, j] * p[f, i, j] for i in 1:n))
@constraint(model, [j = 2:m, f = 1:F, k = 1:K, k1 = 1:K, i = 1:n], (2 - y[f, i, k, j] - y[f, i, k1, j-1])M >= C[f, k1, j-1] + p[f, i, j] - C[f, k, j])
@constraint(model, [i = 1:n, j = 1:m, f = 1:F], sum(y[f, i, k, j] for k in 1:n) == x[f, i])
@constraint(model, [k = 1:n, f = 1:F], Cmax >= C[f, k, m])
# 添加约束：一个工件只能分配给一个工厂  
#@constraint(model, [i = 1:n], sum(y[f, i, k, j] for f in 1:F, k in 1:K, j in 1:m) <= 1)

# 模型求解
optimize!(model)



if termination_status(model) == MOI.OPTIMAL
    println("最优解：")
    println("总完成时间：", objective_value(model))
elseif termination_status(model) == MOI.TIME_LIMIT
    println("目标函数值上界：", objective_value(model))
    println("目标函数值下界：", objective_bound(model))
else
    println("无可行解")
end
# 提取变量值  
y_value = value.(y)
C_value = value.(C)
Cmax_value = value(Cmax)


# 打印每台机器的加工工件顺序  
println("\n每台机器的加工工件顺序:")
for j in 1:m
    println("机器", j, "的加工顺序:")
    for f in 1:F
        # 提取工厂f中机器j的加工顺序  
        machine_jobs = [i for k in 1:K for i in 1:n  if y_value[f, i, k, j] == 1]
        if !isempty(machine_jobs)
            println("工厂", f, "的机器", j, "加工顺序:", machine_jobs)
        end
    end
end

# 打印最大完工时间  
println("\n最大完工时间:", Cmax_value)