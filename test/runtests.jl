using Base.Test
using WorldBankData

my_tests = ["ctrs_indicators.jl",
            "utils.jl",
            "wdi.jl",
            "format.jl",
            "search_wdi.jl"] 

println("Running tests:")

for my_test in my_tests
    println(" * $(my_test)")
    include(my_test)
end

