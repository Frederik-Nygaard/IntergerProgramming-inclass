using JuMP
using GLPK


########################################
n = 6
v = [500 500 300 300 200 100]
a = [360 300 200 150 100 100]

########################################


Container = Model(with_optimizer(GLPK.Optimizer))
@variable(Container, y[1:n], Bin)
@variable(Container, x[1:n,1:n], Bin)

@objective(Container, Min, sum(y[i] for i= 1:n))

@constraint(Container, [i=1:n], sum(x[i,j]+y[i] for j = 1:n) == 1)
@constraint(Container, [j=1:n],sum(a[i]*x[i,j] for i = 1:n) +a[j]*y[j] <= v[j]*y[j] )

solution = optimize!(Container)

println("RESULTS:")
println("Total number of containers: $(objective_value(Container))")

for i in 1:n
    println("Y" ,i ," ", JuMP.value(y[i]))
end
# calculates the total number of worked hours, and substracts the required hours
#for i in 1:D
#    for j in 1:D
#        k[i,j] = sum(JuMP.value(x[i])*m[i,j])
#    end
#end
# overwork = sum(k)-sum(e)
