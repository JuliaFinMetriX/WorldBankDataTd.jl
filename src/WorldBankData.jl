using TimeData
module WorldBankDataTd

using HTTPClient.HTTPC
using JSON
using DataArrays
using DataFrames
using Dates
using TimeData

export #
loadWBMeta,
getWBMeta,
search_wdi,
wdi

include("download.jl")
include("ctrs_indicators.jl")
include("search.jl")
include("utils.jl")

end
