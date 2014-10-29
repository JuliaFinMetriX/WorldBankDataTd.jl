module TestWDICountries

using Base.Test
using DataFrames
using WorldBankData
using Dates

## the worldbank database shows some peculiarities
url =
    "http://api.worldbank.org/countries/afr?per_page=25000&format=json"

## missing values for aggregates are sometimes denoted by "NA"
json = [WorldBankData.download_parse_json(url)[2]]
@test json[1]["incomeLevel"]["id"] == "NA"
@test json[1]["region"]["id"] == "NA"

## and sometimes denoted by ""
@test json[1]["lendingType"]["id"] == ""
@test json[1]["latitude"] == ""
@test json[1]["longitude"] == ""
@test json[1]["adminregion"]["id"] == ""
@test json[1]["adminregion"]["value"] == ""
@test json[1]["capitalCity"] == ""

## iso2c is "NA" for Namibia
url =
    "http://api.worldbank.org/countries/nam?per_page=25000&format=json"

json = [WorldBankData.download_parse_json(url)[2]]
@test json[1]["iso2Code"] == "NA"

end
