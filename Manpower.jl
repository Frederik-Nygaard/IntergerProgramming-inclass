using JuMP
using GLPK

m = [
1 1 1 1 1 0 0;
0 1 1 1 1 1 0;
0 0 1 1 1 1 1;
1 0 0 1 1 1 1;
1 1 0 0 1 1 1;
1 1 1 0 0 1 1;
1 1 1 1 0 0 1;
]
e = [10 5 10 5 10 5 10]
p = [1 2 3 4 5 6 7] #Add a price vector
D = size(e,2)
k = zeros(Float64, D,D)
Manpower = Model(with_optimizer(GLPK.Optimizer))
@variable(Manpower, x[1:D] >= 0, Int)
@objective(Manpower, Min, sum(x[d]*p[d] for d=1:D)) #objevtive changed to minimize total payout
@constraint(Manpower, [d2=1:D], sum(x[d]*m[d,d2] for d=1:7) >= e[d2])
solution = optimize!(Manpower)

println("RESULTS:")
println("Procurement planning result: $(objective_value(Manpower))")

for i in 1:7
    println("X1:" , JuMP.value(x[i]))
end

# calculates the total number of worked hours, and substracts the required hours
for i in 1:D
    for j in 1:D
        k[i,j] = sum(JuMP.value(x[i])*m[i,j])
    end
end
 overwork = sum(k)-sum(e)
