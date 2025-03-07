using LinearAlgebra
using DataFrames
using CSV

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

for i in 1:11
    n = 1000 + i * 200
   
    A = createMatrix(n,0,10,true)
    x = createVector(n,0,10,true)
    y = createVector(n,0,10,true)

    t = @elapsed iloczynSkalarny(x,A,y)
    l = @elapsed mnozenieWektorMacierz(x,A)
    if i != 1
        
        push!(dlugoscWektorow, n)

        
        push!(iloczynSkalarnyCzas, t)

        
        push!(mnozenieWektorMacierzCzas, l)
    end

end



df = DataFrame(LiczbaElementów = dlugoscWektorow,
IloczynSkalarnyCza = iloczynSkalarnyCzas, MnozenieWektorMacierzCzas = mnozenieWektorMacierzCzas)

CSV.write("dataFrame.csv",df)

show(df)