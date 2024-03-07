
# include("NEH_TWT.jl")
# println("Makespan问题",M)
using Random
# println("Makespan问题",M)
function makespan(tal_sol, p, M, J)
    # 初始化批次列表
    sol = copy(tal_sol[1])
    machine_sol = copy(tal_sol[2])
    batches = []
    # 计算批次数
    B = cld(length(sol), M)
    # 分配工件到批次
    # 前B-1个批次
    for b in 1:B-1
        # 取出当前批次的工件
        current_batch = sol[(b-1)*M + 1 : b*M]

        # 将当前批次的工件加入批次列表
        push!(batches, current_batch)
    end
    # 最后一个批次
    last_batch = sol[(B-1)*M + 1 : length(sol)]

    # 将最后一个批次的工件加入批次列表
    push!(batches, last_batch)
    println("batches=",batches)

    # 初始化各个机器的完成时间
    machine_complet = zeros(Int64,M)
    MK = 0
    job_complete = zeros(Int64,J)
   
    for b in 1:B
        cur_batches = copy(batches[b])
        zero_count = count(x -> x == 0, cur_batches)
        println("batches[b]3=",cur_batches)
        println("machine_sol3=",machine_sol)
        if zero_count > 0
            indices_of_zeros = findall(x -> x == 0, sol)
            sol_new = deleteat!(sol, indices_of_zeros)
            machine_sol_new = deleteat!(machine_sol, indices_of_zeros)
            batch_zero = findall(x -> x == 0, cur_batches)
            batches_new = deleteat!(cur_batches, batch_zero)
        else
            batches_new = copy(cur_batches)
            machine_sol_new = copy(machine_sol)
            sol_new = copy(sol)
        end
        println("b=",b)
        println("batches_new4=",batches_new)
        println("machine_sol_new4=",machine_sol_new)
        stage2_start = Inf
        stage3_start = 0
        for (i, j) in enumerate(batches_new)
            k = findfirst(x -> x == j, sol_new)
            r = machine_sol_new[k]
            println("k1=",k)
            println("j1=",j)
            println("r1=",r)
            # println("i = $i, j = $j")
            # 第一阶段
            machine_complet[r] += p[j, 1] 
            println("machine_complet",r,"=",machine_complet[r])
            stage2_start = convert(Int64, min(machine_complet[r], stage2_start))
        end
            
        # 第二阶段
        for i in 1:length(batches_new)
            j = batches_new[i]
            k = findfirst(x -> x == j, sol_new)
            r = machine_sol_new[k]
            println("k2=",k)
            println("j2=",j)
            println("r2=",r)
            if i ==1
                machine_complet[r] += p[j, 2]
                println("machine_complet",r,"=",machine_complet[r])
                # println(machine_complet)
            elseif i > 1 && machine_complet[r] > machine_complet[machine_sol_new[k-1]] 
                machine_complet[r] += p[j, 2]
                println("machine_complet",r,"=",machine_complet[r])
            # println(machine_complet)
            elseif i > 1 && machine_complet[r] <= machine_complet[machine_sol_new[k-1]]
                machine_complet[r] = machine_complet[machine_sol_new[k-1]] + p[j, 2]
                println("machine_complet",r,"=",machine_complet[r])
                # println(machine_complet)   
            end
            a = length(batches_new)
            q = batches_new[a]
            k2 = findfirst(x -> x == q, sol_new)
            r_max = machine_sol_new[k2]
            stage3_start = machine_complet[machine_sol_new[r_max]]
        end
            # println("stage3_start = $stage3_start")
            # 第三阶段
        for (i, j) in enumerate(batches_new)
            k = findfirst(x -> x == j, sol_new)
            r = machine_sol_new[k]
            println("k3=",k)
            println("j3=",j)
            println("r3=",r)
            machine_complet[r] = p[j, 3]+ stage3_start
            println("machine_complet",r,"=",machine_complet[r])
            MK = max(MK, machine_complet[r])
            job_complete[j] = machine_complet[r]
        end
    end
    return job_complete,MK
end

# beta = [11, 13, 8, 27, 18, 30, 3, 1, 15, 17]
# d = [100, 200, 150, 200, 400, 370, 300, 350, 260, 410]
# # 设置参数
# J = 10  # 工件数
# M = 4 # 机器数
# S = 3

# # 生成随机加工时间
# p=[81 44 20; 55 12 13; 32 33 56; 45 5 31; 71 85 9; 51 8 12; 49 63 42; 83 22 15; 93 88 34; 71 45 64]
# # 生成工件序列
# tal_sol = Any[[3, 2, 5, 10, 8, 4, 7, 6, 9, 1], [1, 3, 2, 4, 1, 2, 3, 4, 3, 1]]

# # 计算完成时间
# job_complete,MK = makespan(tal_sol, p, M, J)

# println("job_complete,MK: ", job_complete,MK)

J = 10  # 工件数
M = 5 # 机器数
S = 3

# 生成随机加工时间
p=[81 44 20; 55 12 13; 32 33 56; 45 5 31; 71 85 9; 51 8 12; 49 63 42; 83 22 15; 93 88 34; 71 45 64]
# 生成工件序列
tal_sol = Any[[3, 2, 5, 10, 8, 4, 7, 6, 9, 1], [1, 3, 2, 4, 5, 2, 3, 4, 5, 1]]
d=[90, 80, 179, 144, 107, 160, 198, 150, 161, 172]
beta=[3, 2, 5, 1, 8, 1, 4, 3, 8, 10]

# 生成工件序列
sol = [1, 4, 7, 2, 5, 8, 3, 6]

job_complete,MK = makespan(tal_sol, p, M, J)

println("job_complete,MK: ", job_complete,MK)