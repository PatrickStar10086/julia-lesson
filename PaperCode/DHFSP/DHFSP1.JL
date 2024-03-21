using JuMP, Random, Gurobi

# 创建模型
model = Model(Gurobi.Optimizer)

# 参数定义
C = 2  # 工厂数
J = 5  # 工件数
I = 3  # 加工阶段数量


# 变量
@variable(model, M[1:I, 1:C] >= 0, Int) # 工厂c上车间i的的并行机器数
@variable(model, P[1:J, 1:I] >= 0, Int) # 工件j在车间i的加工时间
@variable(model, S[1:J, 1:I] >= 0, Int) # 工件j的在车间i的加工开始时间
@variable(model, F[1:J, 1:I] >= 0, Int) # 工件j的在车间i的加工结束时间
@variable(model, MS[1:C, 1:] >= 0, Int) 
