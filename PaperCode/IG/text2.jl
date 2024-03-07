# using Random
# using JuMP,JLD
# using BenchmarkTools
# using XLSX
# using DataFrames
# function main_function()

#     p_0, TPT_TWET_p_0 = adaptive_large_neighborhood_search()
    
#     cost, C, Seq = obj_TPT_TWET(p_0, F, p, J, α, β, d, H_W, H_O, H_N, tt, q, a)
    
#     println("Total Cost: ", cost)
 
# end
    
#     # 运行次数
#     num_runs = 10
#     elapsed_times = []
    
    
# for i in 1:num_runs
#      # 使用 @elapsed 宏测量主函数的运行时间
#     elapsed_time = @elapsed main_function()
#     push!(elapsed_times, elapsed_time)
#     println("第 ", i, " 次执行时间：", elapsed_time, " 秒")
# end
    
#     average_elapsed_time = sum(elapsed_times) / num_runs
    
#     println("平均执行时间：", average_elapsed_time, " 秒")

# Seq=[2, 4, 9]
# add_zero=1
# for i in 1:add_zero
#     push!(Seq, 0)
# end
# println("seq=",Seq)

sol=[10, 0, 3, 7]
batches=[10, 0, 3, 7]
machine_sol=[2, 4, 1, 3]
indices_of_zeros = findall(x -> x == 0, sol)
sol = deleteat!(sol, indices_of_zeros)
machine_sol = deleteat!(machine_sol, indices_of_zeros)
batch_zero = findall(x -> x == 0, batches)
batches = deleteat!(batches, batch_zero)
println("batches[b]4=",batches)
println("machine_sol4=",machine_sol)
println("sol=",sol)