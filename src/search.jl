regex_match(df::DataArray{UTF8String,1},regex::Regex) = convert(DataArray{Bool, 1}, map(x -> ismatch(regex,x), df))
df_match(df::AbstractDataFrame,entry::ASCIIString,regex::Regex) = df[regex_match(df[entry],regex),:]

function country_match(entry::ASCIIString,regex::Regex)
    df = get_countries()
    df_match(df,entry,regex)
end

function indicator_match(entry::ASCIIString,regex::Regex)
    df = get_indicators()
    df_match(df,entry,regex)
end

function search_countries(entry::ASCIIString,regx::Regex)
    entries = ["name","region","capital","iso2c","iso3c","income","lending"]
    if !(entry in entries)
        error("unsupported country entry: \"",entry,"\". supported are:\n",entries)
    end
    country_match(entry,regx)
end

function search_indicators(entry::ASCIIString,regx::Regex)
    entries = ["name","description","topics","source_database","source_organization"]
    if !(entry in entries)
        error("unsupported indicator entry: \"",entry,"\". supported are\n",entries)
    end
    indicator_match(entry,regx)
end


# examples:
#   search_wdi("countries","name",r"united"i)
#   search_wdi("indicators","description",r"gross national"i)
function search_wdi(data::ASCIIString,entry::ASCIIString,regx::Regex)
    data_opts = ["countries","indicators"]
    if !(data in data_opts)
        error("unsupported data source:",data,". supported are:\n",data_opts)
    end
    if data == "countries"
        return search_countries(entry,regx)
    end
    if data == "indicators"
        return search_indicators(entry,regx)
    end
end
