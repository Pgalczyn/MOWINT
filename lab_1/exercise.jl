using LinearAlgebra
using DataFrames
using CSV
using Statistics
using Plots

function createMatrix(n,numbersFrom,numbersTo,ifInt)
    # n - rozmiar macierzy (liczba wierszy i kolumn)
    # from - początek zakresu losowanych liczb
    # to - koniec zakresu losowanych liczb
    # IntTrue - czy generować liczby całkowite? (bool)

    if ifInt
        return rand(numbersFrom:1:numbersTo,n,n)
        
    else
        return rand(numbersFrom:.00000001:numbersTo,n,n)
    end

end

function createVector(n,numbersFrom,numbersTo,ifInt)

    if ifInt
        return rand(numbersFrom:numbersTo,n)
    else
        return rand(numbersFrom:.00000001:numbersTo,n)
    end
    
end


function iloczynSkalarny(x,A,y)

    return dot(x,A,y)
    
end

function mnozenieWektorMacierz(x,A)
    return A *x
    
end

mnozenieWektorMacierzCzas = []
iloczynSkalarnyCzas = []
dlugoscWektorow = []
odchyiloczynSkalarny = []
odchymnozenieWektorMacierzCzas = []

for i in 1:11
    n = 1000 + i * 2000
   
    A = createMatrix(n,0,10,true)
    x = createVector(n,0,10,true)
    y = createVector(n,0,10,true)

    tempTime1 = []
    tempTime2 = []

    for j in 1:11
        
            t = @elapsed iloczynSkalarny(x,A,y)
            l = @elapsed mnozenieWektorMacierz(x,A)
        if i != 1
            push!(tempTime1,t)
            push!(tempTime2,l)

    
        end
    end

    if i != 1
        
        push!(dlugoscWektorow, n)

        
        push!(iloczynSkalarnyCzas, mean(tempTime1))
        push!(odchyiloczynSkalarny,std(tempTime1))

        push!(mnozenieWektorMacierzCzas, mean(tempTime2))
        push!(odchymnozenieWektorMacierzCzas,std(tempTime2))
    end

end



df = DataFrame(LiczbaElementów = dlugoscWektorow,
IloczynSkalarnyCzas = iloczynSkalarnyCzas,Odchylenie_Iloczyn_Sklarny = odchyiloczynSkalarny,
 MnozenieWektorMacierzCzas = mnozenieWektorMacierzCzas,Odchylenie_Mnożenie_Wektor_Macierz = odchymnozenieWektorMacierzCzas)

CSV.write("dataFrame.csv",df)

show(df)

myData = CSV.read("dataFrame.csv",delim = ",",DataFrame)


p1 = scatter(myData.LiczbaElementów, myData.IloczynSkalarnyCzas, yerr=myData.Odchylenie_Iloczyn_Sklarny,
             xlabel="Liczba elementów", ylabel="Czas [s]", title="Iloczyn skalarny", label="Czas wykonania", legend=:topleft)

p2 = scatter(myData.LiczbaElementów, myData.MnozenieWektorMacierzCzas, yerr=myData.Odchylenie_Mnożenie_Wektor_Macierz,
             xlabel="Liczba elementów", ylabel="Czas [s]", title="Mnożenie macierzy przez wektor", label="Czas wykonania", legend=:topleft)


plot(p1, p2, layout=(1, 2), size=(1000, 400))