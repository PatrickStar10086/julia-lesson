using Random

function IG_Destruction(d, Sol_Prime)

    n = length(Sol_Prime)
    d_Seq = randperm(n)
    New_Sol_Prime = zeros(Int64,n)
    for j = 1:n
        New_Sol_Prime[j] = Sol_Prime[j] 
    end

    New_Sol_R = zeros(Int64,d)
    for i in 1:d
        New_Sol_Prime[d_Seq[i]] = n+1
        New_Sol_R[i] = Sol_Prime[d_Seq[i]]
    end
    New_Sol_Prime = filter!(x->x!=n+1, New_Sol_Prime)

    return New_Sol_Prime, New_Sol_R
end

# sol = [1, 4, 7, 2, 5, 8, 3, 6]
# d = 3
# New_Sol_Prime, New_Sol_R = IG_Destruction(d, sol)
# println("New_Sol_Prime, New_Sol_R=",New_Sol_Prime, New_Sol_R)




# function Destruction(π, d)
#     n = length(π)
#     d_seq = randperm(n)[1:d]
#     π_prime = π[d_seq]
#     π_double_prime = filter(x -> !(x in π_prime), π)
#     return π_prime, π_double_prime
# end
