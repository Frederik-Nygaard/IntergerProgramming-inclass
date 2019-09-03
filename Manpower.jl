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
D = size(e,2)
Manpower = Model(with_optimizer(GLPK.Optimizer))
@variable(Manpower, x[1:D] >= 0, Int)
@objective(Manpower, Min, sum(x[d] for d=1:D))


@constraint(Manpower, [d2=1:D], sum(x[d]*m[d,d2] for d=1:7) >= e[d2])


solution = optimize!(Manpower)

println("RESULTS:")
println("Procurement planning result: $(objective_value(Manpower))")

for i in 1:7
    println("X1:" , JuMP.value(x[i]))
end
