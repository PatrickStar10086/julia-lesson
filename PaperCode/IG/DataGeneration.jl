
"""
The code generates data for the identical parallel machine scheduling problem with single server and 
a synchronous resource

    #Parameters
    J: Number of Jobs
    M: Number of work stations
    d: due date vector d = [12.0, 14.0, 23.0]
    beta: vector for tardiness cost beta = [1, 2, 1]                                           迟到成本
    p: p_{j,s} two demensional matrix for processing time in production stages

    tau:
    R:

    H: Planning Horizon   should be calculated by the data


"""

using JLD
using HDF5

J = 20
M = 5
tau = 0.4
R = 0.6
index1 = 1


function Data_Generation_IPMSP(J,M,tau,R,index1)

    p = rand(1:100,J,4)    #Processing times   p_{j,s}    s \in {1,2,3,4}

    LB = 0

    LB = div(sum(p),M)


    # Set due dates 

    # Caculate a good makespan as B 
    # d is generated with a Uniform distribution with interval (LB*(1-τ-R/2, LB*(1-τ+R/2)))
   
    println("LB = ", LB)
    d = zeros(Int64, J)
    for j in 1:J
        d[j] = rand(floor(LB*(1-tau-R/2)):floor(LB*(1-tau+R/2)))
    end

    # println("d = ", d)


    beta = rand(1:10, J)


    # i = 3

    filenm = join(["D:/gitworkspace/julia-lesson/PaperCode/IG/Ins_", string(J), "_", string(M), "_", string(tau), "_", string(R), "_", string(index1), ".jld"])
    save(filenm, "JJ",J, "MM", M, "pp", p, "dd", d, "betabeta",beta, "tautau", tau, "RR", R)
    # return J, M, F, p, a, q, r, d, beta, tau, R
  
end


# J, M, p, d, tau, R = Data_Generation_DD(J,M,F,tau,R)
# println("J = ", J)
# println("M = ", M)
# println("p = ", p)
# println("d = ", d)
# println("tau = $tau", " R = $R")

for index1 in 1:10
    Data_Generation_IPMSP(J,M,tau,R,index1)
end




filenm = join(["D:/gitworkspace/julia-lesson/PaperCode/IG/Ins_", string(J), "_", string(M), "_", string(tau), "_", string(R), "_", string(index1), ".jld"])

# println("J = ", J)
# println("M = ", M)
# println("p = ", p)
# println("d = ", d)
# println("tau = $tau", " R = $R")



J = load(filenm,"JJ")
println("J = $J")

M = load(filenm,"MM")
println("M = $M")

p = load(filenm, "pp")
println("p = $p")

d = load(filenm, "dd")
println("d = $d")

beta = load(filenm, "betabeta")
println("beta = $beta")