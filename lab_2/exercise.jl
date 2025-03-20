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
    push!(results, eps(Float64(i)))
end

using Plots
plot(1:10000, results, xlabel="Wartość liczby", ylabel="Odległość (eps)", title="Zmiana odległości między liczbami zmiennoprzecinkowymi", label="eps(x)")


#zadanie 3

decode(x::Float32) = (b=bitstring(x); (b[1], b[2:9], b[10:32]))

numbers = []
for i in 1:50
    push!(numbers, Float32((0.1)^i))
end

for num in numbers
    println(decode(num), issubnormal(num))  
end

#zadanie 4
function count_expencional(numberOfElements,x)
    result::Float16 = 0

    for i=0:numberOfElements

        result += (x^i)/factorial(big(i))


    end

    return result

    
end


println("przybliżenie policzone algorytmem niestabilnym numerycznie: ", count_expencional(40,-5.5))
println("prawdziwa wartość: ",exp(-5.5))
println("różnica: ", exp(-5.5) - count_expencional(40,-5.5))
println("błąd: ", (count_expencional(40,-5.5) - exp(-5.5))/exp(-5.5)," %")

function count_expencional_better(numberOfElements,x)
    result::Float16 = 0

    for i=0:numberOfElements

            result += (x^i)/factorial(big(i))

    end

    return 1/result
    
end

println("przybliżenie policzone algorytmem stabilnym numerycznie: ", count_expencional_better(30,5.5))
println("prawdziwa wartość: ",exp(-5.5))
println("różnica: ", exp(-5.5) - count_expencional_better(30,5.5))
println("błąd: ", (exp(-5.5) - count_expencional_better(40,5.5))/exp(-5.5)," %")