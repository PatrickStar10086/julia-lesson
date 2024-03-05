using JuMP, Clp

print("install_and_check.jl start\n")
model = Model(Clp.Optimizer)
set_attribute(model, "LogLevel", 1)
set_attribute(model, "Algorithm", 4)
print(model)
print("install_and_check.jl end\n")
