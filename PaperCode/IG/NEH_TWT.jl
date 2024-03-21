include("makespan.jl")
include("TWT.jl")
using Random

beta = [11, 13, 8, 27, 18, 30, 3, 1, 15, 17]
d = [100, 200, 150, 200, 400, 370, 300, 350, 260, 410]
# 设置参数
J = 10  # 工件数
M = 4# 机器数
S = 3# 一个工件的生产流程数

# 生成随机加工时间
p = rand(1:100, J, S)
println("p=",p)

function NEH_TWT(beta,d, p, M, J)
    B = cld(J, M)
    set_Seq = []
    set_machine_sol = []
    tal_sol_TWT = 0
    best_tal_sol = []
    # println("TNR_sol2 = ", TNR_sol2)
    PT = sum(p,dims = 2)     # PT denotes the matrix of the sum of processing times of all stages
    PT1 = PT[:,1]
    sol3 = sortperm(-PT1)   # Obtain a sequence by increasing order of PT value
    # TWT_sol3 = TWT(beta,d,sol3, p, M, J)
    # println("TWT_sol3 = ", TWT_sol3)
    sol_prime = zeros(Int64, J)
    for i = 1:J
        sol_prime[i] = sol3[i]
    end
    # println(" sol_prime = ",  sol_prime)
    # NEH-like heursitic

    # Choose the best sequence TNR_sol_NEH between (1,2) and (2,1)

    sol_NEH = [sol_prime[1]; sol_prime[2]]
    M2_sol = randperm(length(sol_NEH))
    tal_sol2 = Array{Any}(undef, 2, 2)
    # println("sol_NEH=",sol_NEH)
    # println("M2_sol=",M2_sol)
    tal_sol2 = []
    tal_sol2 = push!(tal_sol2,sol_NEH)
    tal_sol2 = push!(tal_sol2,M2_sol)

    TWT_sol_NEH = TWT(beta,d,tal_sol2, p, M, J)
    sol_NEH2 = [sol_prime[2]; sol_prime[1]]
    tal_sol3 = Array{Any}(undef, 2, 2)
    # println("sol_NEH=",sol_NEH)
    # println("M2_sol=",M2_sol)
    tal_sol3 = []
    tal_sol3 = push!(tal_sol3,sol_NEH2)
    tal_sol3 = push!(tal_sol3,M2_sol)

    TWT_sol_NEH2 =TWT(beta,d,tal_sol3, p, M, J)
    if TWT_sol_NEH2 < TWT_sol_NEH
        sol_NEH =[sol_prime[2], sol_prime[1]]
        TWT_sol_NEH = TWT_sol_NEH2
    end
    
    # println("sol_NEH = ", sol_NEH)
    # println("TWT_sol_NEH = ", TWT_sol_NEH)
    # println("sol_NEH2 = ", sol_NEH2)
    # println("TWT_sol_NEH2 = ", TWT_sol_NEH2)
    for k in 3:J
        Seq = zeros(Int64,k,k)
        set_Seq = []
        set_machine_sol = []
        # println("Seq[:,i]第一 = ", Seq)
        Seq_new = []
        TWT_Seq = zeros(Int64,k)
        for i in 1:k
            New_sol_NEH = zeros(Int64,length(sol_NEH))
            for u in 1:length(sol_NEH)
                New_sol_NEH[u] = sol_NEH[u]
            end
    
            Seq[:, i] = insert!(New_sol_NEH, i, sol_prime[k])
            # println("New_sol_NEH2 = ", New_sol_NEH)
            # println("Seq[:,i]2 = ", Seq[:,i])
            Seq_new = copy(Seq[:, i])
            # println("i = ", i)
            # println("Seq[:,i] = ", Seq[:,i])
            B_Float = ceil(length(Seq_new) / M)
            B_2 = convert(Int, B_Float)
            # println("B=",B_2)
            # println("数据B的类型: ", typeof(B_2))
            # println(i,"Seq_new1=",Seq_new)
            if length(Seq[:, i]) == B_2*M
                Seq_new = Seq_new
                # println("Seq_new2=",Seq_new)
        
            else
                add_zero = B_2*M - length(Seq[:, i])
                # println("Seq[:, i]=",Seq[:, i])
                # println("Seq_new3=",Seq_new)
                # println("add_zero=",add_zero)
                for i in 1:add_zero
                    push!(Seq_new, 0)
                end
                # println("Seq_new4=",Seq_new)
                sub_arr_2 = Seq_new[((B_2-1)*M+1):B_2*M]
                rand_arr_2 = randperm(length(sub_arr_2))
                Seq_new[((B_2-1)*M+1):B_2*M] = sub_arr_2[rand_arr_2]
                # println("Seq_new5=",Seq_new)
                # println("Seq[:, i]6=",Seq[:, i])
                # TWT_Seq[i] = TWT(beta,d,Seq_new, p, M, J)
            end
            machine_sol = Int[]
            for b in 1:B_2
                 # 生成范围为1到M的随机序列
                M_sol = randperm(M)
                # 将随机序列和分组合并并存入结果数组
                append!(machine_sol, M_sol)
            end
            tal_sol = []
            Seq_new2 = copy(Seq_new)
            machine_sol2 = copy(machine_sol)
            tal_sol = push!(tal_sol,Seq_new)
            # println("tal_sol最后=",tal_sol)
            set_Seq = push!(set_Seq,Seq_new2)
            # println("set_Seq=",set_Seq)
            set_machine_sol = push!(set_machine_sol,machine_sol2)
            # println("set_machine_sol最后=",set_machine_sol)
            tal_sol = push!(tal_sol,machine_sol)
            TWT_Seq[i] = TWT(beta, d, tal_sol, p, M, J)
            # println("TWT_Seq无敌 =",TWT_Seq)
        end
        ~,best_index = findmin(TWT_Seq)     # find the job index with the minimum of makespan values
        # println("TWT_Seq超级 =",TWT_Seq)
        sol_NEH = Seq[:,best_index]
        best_seq_new = set_Seq[best_index]
        best_machine_sol = set_machine_sol[best_index]
        tal_sol_TWT = TWT_Seq[best_index]
        best_tal_sol = []
        # println("best_seq_new=",best_seq_new)
        # println("best_machine_sol=",best_machine_sol)
        best_tal_sol = push!(best_tal_sol,best_seq_new)
        best_tal_sol = push!(best_tal_sol,best_machine_sol)
    end
    return best_tal_sol,tal_sol_TWT
end


 


tal_sol, tal_sol_TWT = NEH_TWT(beta, d, p, M, J)

println("tal_sol,tal_sol_TWT = ", tal_sol, tal_sol_TWT)


