using JuMP, Random, Gurobi

# 创建模型
model = Model(Gurobi.Optimizer)

# 参数定义
F = 2  # 工厂数
n = 5  # 工件数
m = 3  # 加工阶段数量


# 设置随机数生成器的种子，以确保结果可重复
Random.seed!(123)

u = Array{Int}(undef, n, n, F, m)
for i in 1:n
    for j in 1:n
        for f in 1:F
            for g in 1:m
                if i == j
                    u[i, j, f, g] = 0
                    continue
                else
                    u[i, j, f, g] = rand(5:10)
                end
            end
        end
    end
end
p = Array{Int}(undef, n, F, m)
for i in 1:n
    for f in 1:F
        for g in 1:m
            p[i, f, g] = rand(10:80)
        end
    end
end

println("u = ", u);
println("p = ", p);

# S[m] = {3,3,4,2}  # 车间（加工阶段）g的并行机器数
H = 1000  # 一个足够大的数

# 变量
# @variable(model, S[1:m] >= 0, Int) # 车间（加工阶段）g的并行机器数
# @variable(model, 80 >= p[1:n, 1:F, 1:m, 1:k] >= 10, Int) # 工件i在工厂f的车间g的机器k上的加工时间
# @variable(model, 80 >= p[1:n, 1:F, 1:m] >= 10, Int) # 工件i在工厂f的车间g的机器k上的加工时间

# @variable(model, dmax >= d[1:n] >= dmin, Int) # 工件i的交货期

# @variable(model, u[1:j, 1:i, 1:F, 1:m, 1:k] >= 0, Int) # 工件j,i在机器Mf,g,k上依次加工时,工件i的准备时间
# @variable(model, 10 >= u[0:n, 1:n, 1:F, 1:m] >= 5, Int) # 工件j,i在机器Mf,g,k上依次加工时,工件i的准备时间

# @variable(model, 10 >= u[0, 1:n, 1:F, 1:m, 1:k] >= 5, Int) # 工件j,i首次在机器Mf,g,k上依次加工时,工件i的准备时间
# @variable(model, 10 >= u[0, 1:n, 1:F, 1:m] >= 5, Int) # 工件j,i首次在机器Mf,g,k上依次加工时,工件i的准备时间

@variable(model, B[1:n, 1:m] >= 0, Int) # 工件i在车间g的加工开始时间
@variable(model, C[1:n, 1:m] >= 0, Int) # 工件i在车间g的加工完成时间
@variable(model, Cf[1:n] >= 0, Int) # 工件i的加工完成时间
@variable(model, Cmax>= 0, Int) # 最大完工时间
# @variable(model, Tmax, Int) # 最大延迟时间
# 决策变量
@variable(model, x[1:n, 1:F], Bin) # 工件i是否在工厂f加工，是为1，否为0
# @variable(model, y[1:n, 1:F, 1:m, 1:k], Bin) # 工件i是否在工厂f的车间g的机器k上加工，是为1，否为0
@variable(model, y[1:n, 1:F, 1:m], Bin) # 工件i是否在工厂f的车间g的机器k上加工，是为1，否为0

# @variable(model, z[1:j, 1:n, 1:F, 1:m, 1:k], bin) # 工序j是否先于工件i在工厂f的车间g的机器k上加工，是为1，否为0
@variable(model, z[1:n, 1:n, 1:F, 1:m], Bin) # 工序j是否先于工件i在工厂f的车间g的机器k上加工，是为1，否为0


# 目标函数
@objective(model, Min, Cmax) # 最小化最大完工时间

# 约束s
@constraint(model, [i in 1:n], sum(x[i, f] for f in 1:F) == 1) # 每个工件只能在一个工厂加工
# @constraint(model, [i in 1:n, f in 1:F], sum(y[i, f, g] for g in 1:m) <= x[i, f]) # 如果工件i在工厂f加工，则工件i在工厂f的车间g的机器k上加工
@constraint(model, [i in 1:n, f in 1:F], sum(y[i, f, g] for g in 1:m) == 1) # 如果工件i在工厂f加工，则工件i在工厂f的车间g的机器k上加工

@constraint(model, [i in 1:n, g in 2:m], B[i, g] >= C[i, g-1]) # 工件i在车间g的加工开始时间大于等于工件i在车间g-1的加工完成时间
# @constraint(model, [i in 1:n, j in 1:n, i != j, f in 1:F, g in 1:m], C[i, g] >= C[j, g] + u[j, i, f, g] + p[i, f, g] - (1 - z[j, i, f, g]) * H) # 工序j是否先于工件i在工厂f的车间g的机器k上加工
@constraint(model, [i in 1:n-1, j in i+1:n,  f in 1:F, g in 1:m], C[i, g] >= C[j, g] + u[j, i, f, g] + p[i, f, g] - (1 - z[j, i, f, g]) * H)
@constraint(model, [i in 1:n-1, j in i+1:n,  f in 1:F, g in 1:m], C[j, g]>= C[i, g]  + u[i, j, f, g] + p[j, f, g] - z[j, i, f, g] * H) # 工序j是否先于工件i在工厂f的车间g的机器k上加工
@constraint(model, [i in 1:n],Cmax >= C[i, m]) # 工件i的加工完成时间等于工件i在车间m的加工完成时间
# @constraint(model, [i in 1:n], Cmax >= Cf[i]) # 最大完工时间大于等于工件i的加工完成时间


# 求解优化问题
JuMP.set_time_limit_sec(model, 7200)  # 设置时间限制
JuMP.optimize!(model)    #求解模型

println("最大完工时间: ", value(Cmax))

println("x: ", x)

for i in 1:n
    for f in 1:F
        println("x[$i,$f]: ", value(x[i, f]))

        # if value(x[i, f]) == 1
        #     println("工件 $i 在工厂 $f 加工")
        #     println("加工开始时间 B[$i,$f,$m]: ", value(B[i, f, m]))
        #     println("加工完成时间 C[$i,$f,$m]: ", value(C[i, f, m]))
        #     break;
        # end
    end
end
