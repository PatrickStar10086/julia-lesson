using JuMP, Gurobi

# 定义问题参数
n = 10  # 工件数量
m = 5   # 机器数量
prep_time = rand(1:10, n, m)  # 每个工件在每台机器上的准备时间

# 创建模型
model = Model(Gurobi.Optimizer)

# 定义决策变量
@variable(model, x[i=1:n, j=1:m], Bin)  # 如果工件i在机器j上加工，则x[i,j]=1，否则为0
@variable(model, s[i=1:n] >= 0)  # 工件i的开始加工时间
@variable(model, c[i=1:n] >= 0)  # 工件i的完成加工时间

# 定义约束条件
for i in 1:n
    for j in 1:m
        # 工件i的开始加工时间必须在其在机器j上的加工完成时间之后，加上准备时间
        if i>1
            @constraint(model, s[i] >= c[i-1] + x[i-1,j] + prep_time[i,j])
        end
    end
    # 工件i的完成加工时间必须在其开始加工时间之后
    @constraint(model, c[i] >= s[i] + sum(x[i,j] for j in 1:m))
end

# 定义目标函数（最小化最大完成时间）
@objective(model, Min, max(c[i] for i in 1:n))

# 求解模型
optimize!(model)