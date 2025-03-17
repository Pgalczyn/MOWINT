#zadanie 1

println(Float16(1/3))
println(Float32(1/3))
println(Float64(1/3))

x = Float16(1/3)
y = Float64(x)
println("-------------------")
println(y)


#zadanie 2

results = []

for i in 1:10000

    push!(results,eps(Float64(i)))

end

using Plots
plot(1:10000,results)


#zadanie 3

decode(x::Float32) = (b=bitstring(x); (b[1], b[2:9], b[10:32]))

numbers = []
for i in 1:50
    push!(numbers, Float32((0.1)^i))
end

for num in numbers
    println(decode(num), issubnormal(num))  
end



