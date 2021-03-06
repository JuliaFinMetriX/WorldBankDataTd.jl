
module TestDocumentation

using Base.Test
using DataFrames
using TimeData

println("\n Running documentation tests\n")

using WorldBankDataTd
   
## single indicator, single country
gnp = WorldBankDataTd.wdi("NY.GNP.PCAP.CD", "BR")

## single indicator, multiple countries
gnp = WorldBankDataTd.wdi("NY.GNP.PCAP.CD", ["BR", "US", "DE"])

## multiple indicators, single country
data = WorldBankDataTd.wdi(["NY.GNP.PCAP.CD", "SP.DYN.LE00.IN"],
                         "BR")

## multiple indicators, multiple countries
data = WorldBankDataTd.wdi(["NY.GNP.PCAP.CD", "SP.DYN.LE00.IN"],
                         ["BR", "US", "DE"])

## same, but as DataFrame
data = WorldBankDataTd.wdi(["NY.GNP.PCAP.CD", "SP.DYN.LE00.IN"],
                         ["BR", "US", "DE"],
                         format = DataFrame)

## multiple indicators, multiple countries, additional information
data = WorldBankDataTd.wdi(["NY.GNP.PCAP.CD", "SP.DYN.LE00.IN"],
                         ["BR", "US", "DE"], extra = true)

data[1:5, :]

countryData = getWBMeta("countries")
countryData[1:5, :]

names(countryData)

size(countryData)

indicatorData = getWBMeta("indicators")
indicatorData[1:5, :]

names(indicatorData)

size(indicatorData)

WorldBankDataTd.country_cache[1:5, :]

WorldBankDataTd.indicator_cache[1:5, :]

res = search_wdi("countries", :name, r"united"i)
res

res = search_wdi("indicators", :description, r"gross national expenditure"i)
res[:name]

search_wdi("countries", :iso2c, r"TZ"i)
search_wdi("countries", :income, r"upper middle"i)
search_wdi("countries", :region, r"Latin America"i)
search_wdi("countries", :capital, r"^Ka"i)
search_wdi("countries", :lending, r"IBRD"i)
search_wdi("indicators", :name, r"gross national expenditure"i)
search_wdi("indicators", :description, r"gross national expenditure"i)
search_wdi("indicators", :source_database, r"Sustainable"i)
search_wdi("indicators", :source_organization,
           r"Global Partnership"i)[1:5, :]

data = wdi("NY.GNP.PCAP.CD", ["US","BR"], 1980, 2012, extra = true)
usData = chkDates(x-> x[:iso2c] .== "US", eachdate(data)) |>
         x -> asArr(x, Bool, false) |>
         x -> data[x[:], :]
usData

dfAS = wdi("EN.ATM.CO2E.KT", "AS")

end
