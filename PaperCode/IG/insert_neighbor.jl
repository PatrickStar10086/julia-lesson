include("NEH_TWT.jl")

function insert_neighbor(sol, beta, d, p, M, J)
    best_sol = copy(sol)
    best_twt = Inf
    # best_sol,best_twt = NEH_TWT(beta,d, p, M, J)
    
    # 遍历每个工件
    for j in 1:J
        # 从当前解中移除工件
        removed = filter(x -> x != j, best_sol)
        
        # 尝试将工件插入到所有可能位置
        for k in 1:length(removed)+1
            new_sol = insert!(copy(removed), k, j)
            twt = TWT(beta, d, new_sol, p, M, J)
            
            # 如果找到更优的解，则更新最优解和最优TWT值
            if twt < best_twt
                best_sol = new_sol
                best_twt = twt
            end
        end
    end
    
    return best_sol, best_twt
end
