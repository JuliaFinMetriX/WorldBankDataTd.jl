module WorldBankData

using HTTPClient.HTTPC
using JSON
using DataArrays
using DataFrames
using Base.Dates

export wdi, search_wdi

include("download.jl")
include("ctrs_indicators.jl")
include("search.jl")
include("utils.jl")

end
