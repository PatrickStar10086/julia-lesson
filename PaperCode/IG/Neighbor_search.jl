include("NEH_TWT.jl")
include("swap_neighbor.jl")
include("insert_neighbor.jl")

using Random

max_iterations = 50

function random_neighbor_search(beta, d, p, M, J, max_iterations)
    best_sol, best_twt = NEH_TWT(beta, d, p, M, J)  # 初始解通过NEH_TWT函数得到
    current_sol = best_sol
    current_twt = best_twt

    iterations = 0
    while iterations < max_iterations
        iterations += 1
        # 从当前解中随机选择一个订单
        selected_j = rand(1:J)
        # 随机选择插入邻域或交换邻域
        if rand() < 0.5
            # 插入邻域搜索
            new_sol, new_twt = insert_neighbor(current_sol , beta, d, p, M, J)
        else
            # 交换邻域搜索
            new_sol, new_twt = swap_neighbor(current_sol , beta, d, p, M, J)
        end

        # 如果找到的新解优于当前解，则替换当前解
        if new_twt < current_twt
            current_sol = new_sol
            current_twt = new_twt
            if new_twt < best_twt
                best_sol = new_sol
                best_twt = new_twt
            end
        end
    end

    return best_sol, best_twt
end


# beta = [11, 13, 8, 27, 18, 30, 3, 1]
# d = [100, 200, 150, 200, 400, 370, 300, 350]
# # 设置参数

# J = 8  # 工件数
# M = 4  # 机器数
# S = 4

# # 生成随机加工时间
# p = rand(1:100, J, S)
# println(p)

# # 生成工件序列
# sol = [1, 4, 7, 2, 5, 8, 3, 6]

# #最大迭代次数
# max_iterations = 1000

# result = random_neighbor_search(beta, d, p, M, J, max_iterations)

# println("best_sol = ", result[1])
# println("best_twt = ", result[2])