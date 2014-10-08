# examples:
#   search_wdi("countries","name",r"united"i)
#   search_wdi("indicators","description",r"gross national"i)
function search_wdi(data::ASCIIString,entry::Symbol,regx::Regex)
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


function regex_match(df::DataArray{UTF8String,1},
                     regex::Regex)
    return convert(DataArray{Bool, 1}, map(x -> ismatch(regex,x), df))
end

function df_match(df::AbstractDataFrame,
                  entry::Symbol,
                  regex::Regex)
    return df[regex_match(df[entry],regex),:] # use symbol to get
                                        # column 
end

function country_match(entry::Symbol,regex::Regex)
    df = get_countries()
    df_match(df,entry,regex)
end

function indicator_match(entry::Symbol,regex::Regex)
    df = get_indicators()
    df_match(df,entry,regex)
end

function search_countries(entry::Symbol,regx::Regex)
    # test whether chosen column name is valid
    entries = [ :iso3c,
               :iso2c,
               :name,
               :region,
               :regionId,
               :capital,
               :longitude,
               :latitude,
               :income,
               :incomeId,
               :lending,
               :lendingId
               ]
    
    if !(entry in entries)
        error("unsupported country entry: \"",entry,"\". supported are:\n",entries)
    end
    country_match(entry,regx)
end

function search_indicators(entry::Symbol,regx::Regex)
    # test whether chosen column name is valid
    entries = [ :indicator,
               :name,
               :description,
               :source_database,
               :source_databaseId,
               :source_organization
               ]

    if !(entry in entries)
        error("unsupported indicator entry: \"",entry,"\". supported are\n",entries)
    end
    indicator_match(entry,regx)
end


