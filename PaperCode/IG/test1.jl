# # 工件总数
# total_workpieces = 10

# # 每台机器分配的工件数
# workpieces_per_machine = 3

# # 计算批次数（向上取整）
# batches = ceil(total_workpieces / workpieces_per_machine)

# println("批次数: ", batches)
# 导入Random库，用于生成随机数
using Random

# # 原始列表
# sol = [1, 4, 7, 2, 5, 8, 3, 6]

# # 每M个数为一组
# M = 3

# # 生成范围为1到M的随机序列
# random_sequences = randperm(M)

# # 输出随机序列
# println("随机序列: ", random_sequences)

# # 原始数组
# arr = [1, 2, 3, 4, 5, 6, 7, 8, 0, 0]

# # 提取第8个数到第10个数的子数组
# sub_array = arr[8:10]
# println("sub_array=",sub_array)

# # 生成该子数组的随机排列
# random_permutation = randperm(length(sub_array))
# println("random_permutation=",random_permutation)

# # 将随机排列后的值放回原数组的相应位置
# arr[8:10] = sub_array[random_permutation]

# # 输出结果
# println("随机变化后的数组: ", arr)

# B = cld(10, 3)
# println("B=",B)
# println("数据B的类型: ", typeof(B))
# # 原始数据
# sol_NEH = [5, 4, 2, 6, 10, 3, 7, 9, 1, 0, 0, 8]
# machine_sol = Any[4, 2, 3, 1, 1, 2, 4, 3, 4, 1, 2, 3]

# # 创建一个新的整数类型数组，并逐个转换元素类型
# new_machine_sol = Int[machine_sol[i] for i in 1:length(machine_sol)]

# # 输出结果
# println("新的 machine_sol 数组: ", new_machine_sol)
# println("新的 machine_sol 的类型: ", typeof(new_machine_sol))
# sol_NEH=[2, 4, 8, 6, 3, 7, 9, 10, 5, 1, 0, 0]
# machine_sol=[1, 4, 2, 3, 2, 3, 4, 1, 4, 3, 1, 2]

# # 初始化 tal_sol 为指定的二维数组
# tal_sol = hcat(sol_NEH, machine_sol)'

# # 输出结果
# println("tal_sol 数组: ", tal_sol)
# println("tal_sol 的类型: ", typeof(tal_sol))

# # sol_NEH 和 machine_sol 数据
# sol_NEH = [2, 4, 8, 6, 3, 7, 9, 10, 5, 1, 0, 0]
# machine_sol = [1, 4, 2, 3, 2, 3, 4, 1, 4, 3, 1, 2]

# # 创建二维数组
# tal_sol = [sol_NEH; machine_sol]

# # 输出结果
# println("tal_sol 数组: ", tal_sol)
# println("tal_sol 的类型: ", typeof(tal_sol))
# # sol_NEH 和 machine_sol 数据
# sol_NEH = [2, 4, 8, 6, 3, 7, 9, 10, 5, 1, 0, 0]
# machine_sol = [1, 4, 2, 3, 2, 3, 4, 1, 4, 3, 1, 2]
# tal_sol=[]
# # 创建二维数组
# tal_sol = push!(tal_sol,sol_NEH)
# tal_sol = push!(tal_sol,machine_sol)

# # 输出结果
# println("tal_sol 数组: ", tal_sol)
# println("tal_sol 的类型: ", typeof(tal_sol))
using Random
# beta = [11, 13, 8, 27, 18, 30, 3, 1, 15, 17]
# d = [100, 200, 150, 200, 400, 370, 300, 350, 260, 410]
# # 设置参数
# J = 10  # 工件数
# M = 4  # 机器数
# S = 3

# # 生成随机加工时间
# p = rand(1:100, J, S)
# # 生成工件序列
# tal_sol = Any[[10, 1, 3, 4, 8, 5, 9, 7, 2, 6, 0, 0], [4, 1, 3, 2, 2, 4, 1, 3, 1, 3, 2, 4]]
# sol = tal_sol[1]
# println("tal_sol[1]=",sol)
# machine_sol = tal_sol[2]
# println("tal_sol[2]=",machine_sol)


# batches = []
# # 计算批次数
# B = cld(length(sol), M)
# # 分配工件到批次
# # 前B-1个批次
# for b in 1:B-1
#     # 取出当前批次的工件
#     current_batch = sol[(b-1)*M + 1 : b*M]

#     # 将当前批次的工件加入批次列表
#     push!(batches, current_batch)
# end
# # 最后一个批次
# last_batch = sol[(B-1)*M + 1 : length(sol)]
# # 将最后一个批次的工件加入批次列表
# push!(batches, last_batch)
# println("batches=",batches)

#     # 计算各个工件的完成时间
#     for b in 1:1
#         stage2_start = Inf
#         stage3_start = 0
#         for (i, j) in enumerate(batches[b])
#             k = findfirst(x -> x == j, sol)
#             r = machine_sol[k]
#             # println("i = $i, j = $j")
#             # 第一阶段
#             machine_complet[r] += p[j, 1]    
#             stage2_start = convert(Int64, min(machine_complet[r], stage2_start))

#         end
#         # println("stage2_start = $stage2_start")
#         # println("machine_complet= $machine_complet")
            
#         # 第二阶段
#         for i in 1:length(batches[b])
#             j = batches[b][i]
#             k = findfirst(x -> x == j, sol)
#             r = machine_sol[k]
#             if i ==1
#                 machine_complet[r] += p[j, 2]
#                 # println(machine_complet)
#             elseif i > 1 && machine_complet[r] > machine_complet[machine_sol[k-1]] 
#                 machine_complet[r] += p[j, 2]
#                # println(machine_complet)
#             elseif i > 1 && machine_complet[r] <= machine_complet[machine_sol[k-1]]
#                 machine_complet[r] = machine_complet[i-1] + p[j, 2]
#                 # println(machine_complet)   
#             end
#             a = length(batches[b])
#             q = batches[b][a]
#             k2 = findfirst(x -> x == q, sol)
#             r_max = machine_sol[k2]
#             stage3_start = machine_complet[machine_sol[r_max]]
#         end
#             # println("stage3_start = $stage3_start")
#             # 第三、四阶段
#         for (i, j) in enumerate(batches[b])
#             k = findfirst(x -> x == j, sol)
#             r = machine_sol[k]
#             machine_complet[r] = p[j, 3]+ stage3_start
#             MK = max(MK, machine_complet[r])
#             job_complete[j] = machine_complet[r]
#         end
#     end

    # 原始数组
tal_sol_row_1 = [10, 1, 3, 4, 8, 5, 9, 7, 0, 6, 0, 2]

# 找到值为0的元素的索引
indices_of_zeros = findall(x -> x == 0, tal_sol_row_1)

# 输出结果
println("值为0的元素索引: ", indices_of_zeros)
# 原始数组
arr = [2, 4, 3, 1, 2, 4, 3, 1, 2, 4, 1, 3]

# 要去掉的索引数组
indices_to_remove = [9, 11]

# 从数组中删除指定索引位置的元素
new_arr = deleteat!(arr, indices_to_remove)

# 输出结果
println("删除指定索引后的数组: ", new_arr)

