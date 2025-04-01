using Polynomials
using Plots
using LinearAlgebra
using DataFrames
using CSV
using Statistics
# zadanie 1

function wielomianyBazowe(xs)
    n = length(xs)
    L = Vector{Function}(undef,n)

    for k in 1:n
        function l_k(x)

            d = 1
            m = 1
            for i in 1:n
    
                if(i != k)
        
                    d *= (x - xs[i])
                    m *= (xs[k] - xs[i])
        
                end
        
            end

            return d/m
        end
        
        L[k] = l_k
        
    end

    return L
end

function getPolynomal(L,ys,xs)
    n = length(xs)
    
    function P(x)
        result = 0.0
        for i in 1:n

            result += ys[i] * L[i](x)
    
        end
    
        return result
    
        
    end

    return P 
end



xs = 1:10
ys = [rand(1:10) for x in xs]

L = wielomianyBazowe(xs)
P = getPolynomal(L,ys,xs)

test = 0:0.01:10

dopasowanie = [P(x) for x in test]

scatter(xs, ys, label="wylosowane wartości", markersize=2, alpha=0.5)
plot!(test, dopasowanie, label="wielomian Lagrange'a", linewidth=2,
      legend=:topright, xlims=(1,10), ylims = (-100,100))
title!("Interpolacja Lagrange'a dla 100 punktów")
xlabel!("x")
ylabel!("y")


# zadanie 2


function newtonInterpolation(xs ,ys)
    n = length(xs)
    newt = zeros(n,n)

    newt[:,1] = ys

    for j in 2:n
        for i in j:n  
            newt[i,j] = (newt[i,j-1] - newt[i-1,j-1]) / (xs[i] - xs[i-j+1])
        end
    end

    return newt;    
end

function newtonHorner(xs,newt)
    n = length(xs)
    function P(x)
        result = newt[1,1]
        y = 1
        z = 1
        for i in 2:n

            z *= (x - xs[i-1])

            result += newt[i,i] * z
            y += 1
        end
        return result
    end
    return P 
end


xs = 1:10
ys = [rand(1:10) for x in xs]

newt = newtonInterpolation(xs,ys)
P = newtonHorner(xs,newt)

test = 0:0.01:10

dopasowanie = [P(x) for x in test]

scatter(xs, ys, label="wylosowane wartości", markersize=2, alpha=0.5)
plot!(test, dopasowanie, label="wielomian Lagrange'a", linewidth=2,
      legend=:topright, xlims=(1,10), ylims = (-100,100))
title!("Interpolacja Lagrange'a dla 100 punktów")
xlabel!("xddd")
ylabel!("y")



# zadanie 3
xs = 1:30
ys = [rand(1:10) for x in xs]

scatter(xs, ys, label="wylosowane wartości", markersize=2, alpha=0.5)


L = wielomianyBazowe(xs)
P = getPolynomal(L,ys,xs)

test = 0:0.01:10

dopasowanie = [P(x) for x in test]

plot!(test, dopasowanie, label="wielomian Lagrange'a", linewidth=2,
      legend=:topright, xlims=(1,10), ylims = (-100,100))


      
newt = newtonInterpolation(xs,ys)
P = newtonHorner(xs,newt)


test = 0:0.01:10

dopasowanie1 = [P(x) for x in test]

plot!(test,extrema(xs), dopasowanie1, label="wielomian Lagrange'a", linewidth=2,
      legend=:topright,)


using Polynomials
f=fit(xs, ys)
plot!(f,  extrema(xs)..., label="polynomial interpolation")



# zadanie 4



using Statistics
using DataFrames
using Plots

function timeMeasure()
    LiczbaElementów = Float64[]
    lagrangeOdchylenie = Float64[]
    newtonOdchylenie = Float64[]
    polynomalOdchylenie = Float64[]

    lagrangeCzas = Float64[]
    newtonCzas = Float64[]
    polynomalCzas = Float64[]

    # Jeśli te zmienne są potrzebne, inicjujemy je tak samo
    newtonWpunkcie = Float64[]
    polynomalWpunkcie = Float64[]
    newtonWpunkcieOdchylenie = Float64[]
    polynomalWpunkcieOdchylenie = Float64[]

    for i in 2:11  # zaczynamy od 2, żeby mieć pomiary (albo usunąć warunek if wewnątrz)
        xs = 1:(i * 100)  
        ys = [rand(1:(i * 100)) for _ in xs]
        x0 = (first(xs) + last(xs)) / 2  # środkowy punkt przedziału
        push!(LiczbaElementów,last(xs))
        # Tymczasowe tablice dla pomiarów
        tempTime1 = Float64[]
        tempTime2 = Float64[]
        tempTime3 = Float64[]
        tempTime4 = Float64[]
        tempTime5 = Float64[]

        for j in 1:10  # 10 powtórzeń
            elapsed_time1 = @elapsed begin
                L = wielomianyBazowe(xs)
                P = getPolynomal(L, ys, xs)
            end

            elapsed_time2 = @elapsed begin
                newt = newtonInterpolation(xs, ys)
                P_newton = newtonHorner(xs, newt)
            end

            elapsed_time3 = @elapsed begin
                f = fit(xs, ys)
            end

            elapsed_time4 = @elapsed begin
                f = fit(xs, ys)
                f(x0)
            end

            elapsed_time5 = @elapsed begin
                newt = newtonInterpolation(xs, ys)
                P_newton = newtonHorner(xs, newt)
                P_newton(x0)
            end

            # Zapisujemy wyniki
            push!(tempTime1, elapsed_time1)
            push!(tempTime2, elapsed_time2)
            push!(tempTime3, elapsed_time3)
            push!(tempTime4, elapsed_time4)
            push!(tempTime5, elapsed_time5)
        end

        # Średnie i odchylenia standardowe
        push!(lagrangeCzas, mean(tempTime1))
        push!(lagrangeOdchylenie, std(tempTime1))

        push!(newtonCzas, mean(tempTime2))
        push!(newtonOdchylenie, std(tempTime2))

        push!(polynomalCzas, mean(tempTime3))
        push!(polynomalOdchylenie, std(tempTime3))

        push!(polynomalWpunkcie, mean(tempTime4))
        push!(polynomalWpunkcieOdchylenie, std(tempTime4))

        push!(newtonWpunkcie, mean(tempTime5))
        push!(newtonWpunkcieOdchylenie, std(tempTime5))
    end

    # Tworzymy DataFrame'y
    df1 = DataFrame(
        LiczbaElementów = LiczbaElementów,
        lagrange = lagrangeCzas,
        lagrangeOdchylenie = lagrangeOdchylenie,
        newton = newtonCzas,
        newtonOdchylenie = newtonOdchylenie,
        polynomal = polynomalCzas,
        polynomalOdchylenie = polynomalOdchylenie
    )
    df2 = DataFrame(
        LiczbaElementów = LiczbaElementów,
        newtonPunkt = newtonWpunkcie,
        newtonPunktOdchylenie = newtonWpunkcieOdchylenie,
        polynomalPunkt = polynomalWpunkcie,
        polynomalOdchyleniePunkt = polynomalWpunkcieOdchylenie
    )

    return df1, df2
end

df1, df2 = timeMeasure()


scatter(df1.LiczbaElementów, df1.lagrange   , yerr= df1.lagrangeOdchylenie,
             xlabel="Liczba elementów", ylabel="Czas [s]", title="Interpolacja czas", label="lagrange", legend=:topleft)

scatter!(df1.LiczbaElementów, df1.newton, yerr=df1.newtonOdchylenie,
             label="Newton", color=:red)

scatter!(df1.LiczbaElementów, df1.polynomal, yerr=df1.polynomalOdchylenie,
             label="Polynomials.jl", color=:blue)

scatter(df2.LiczbaElementów,df2.newtonPunkt, yerr = df2.newtonPunktOdchylenie,
        xlabel = "Liczba elementów", ylabel="Czas [s]", title="Interpolacja czas", label="newton w punkcie", legend=:topleft)

scatter!(df2.LiczbaElementów, df2.polynomalPunkt, yerr = df2.polynomalOdchyleniePunkt, label = "polynolmal w punkcie",color =:blue)