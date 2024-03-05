using JuMP
using HiGHS

print("JuMP_and_HiHGS.jl  start\n")
model = Model(HiGHS.Optimizer)

@variable(model, x >=0)
@variable(model, 0 <= y <= 3)
@objective(model, Min, 12x + 20y)
@constraint(model, c1, 6x + 8y >= 100)
@constraint(model, c2, 7x + 12y >= 120)
# print(model)

optimize!(model)
print("JuMP_and_HiHGS.jl   end\n")