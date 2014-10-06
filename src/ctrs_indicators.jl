function get_countries()
    if country_cache == false
        set_country_cache(download_countries())
    end
    country_cache
end

function get_indicators()
    if indicator_cache == false
        set_indicator_cache(download_indicators())
    end
    indicator_cache
end

function parse_indicator(json::Array{Any,1})
    indicator = ASCIIString[]
    name = UTF8String[]
    description = UTF8String[]
    source_database = UTF8String[]
    source_organization = UTF8String[]

    for d in json[2]
        append!(indicator,[d["id"]])
        append!(name,[d["name"]])
        append!(description,[d["sourceNote"]])
        append!(source_database, [d["source"]["value"]])
        # d["source"]["id"] not fetched
        append!(source_organization, [d["sourceOrganization"]])
    end

    DataFrame(indicator = indicator, name = name,
              description = description,
              source_database = source_database,
              source_organization = source_organization)
end

function tofloat(f::String)
     try
         return float(f)
     catch
         return NA
     end
end

function parse_country(json::Array{Any,1})
    iso3c = ASCIIString[]
    iso2c = ASCIIString[]
    name = UTF8String[]
    capital = UTF8String[]
    longitude = UTF8String[]
    latitude = UTF8String[]
    region = UTF8String[]
    regionId = UTF8String[]
    income = UTF8String[]
    incomeId = UTF8String[]
    lending = UTF8String[]
    lendingId = UTF8String[]

    for d in json[2]
        append!(iso3c,[d["id"]])
        append!(iso2c,[d["iso2Code"]])
        append!(name,[d["name"]])
        append!(capital,[d["capitalCity"]])
        append!(longitude,[d["longitude"]])
        append!(latitude,[d["latitude"]])
        append!(region,[d["region"]["value"]])
        append!(income,[d["incomeLevel"]["value"]])
        append!(lending,[d["lendingType"]["value"]])
        append!(regionId,[d["region"]["id"]])
        append!(incomeId,[d["incomeLevel"]["id"]])
        append!(lendingId,[d["lendingType"]["id"]])

    end

    longitude = [tofloat(i) for i in longitude]
    latitude = [tofloat(i) for i in latitude]

    DataFrame(iso3c = iso3c, iso2c = iso2c, name = name,
              region = region, regionId = regionId,
              capital = capital, longitude = longitude,
              latitude = latitude, income = income,
              incomeId = incomeId, lending = lending,
              lendingId = lendingId)
end

function download_indicators()
    dat = download_parse_json("http://api.worldbank.org/indicators?per_page=25000&format=json")

    parse_indicator(dat)
end

function download_countries()
    dat = download_parse_json("http://api.worldbank.org/countries/all?per_page=25000&format=json")

    parse_country(dat)
end

country_cache = false
indicator_cache = false

function set_country_cache(df::AbstractDataFrame)
    global country_cache = df
    if any(isna(country_cache[:iso2c])) # the iso2c code for North Africa is NA
        country_cache[:iso2c][convert(DataArray{Bool,1}, isna(country_cache[:iso2c]))]="NA"
    end
end

function set_indicator_cache(df::AbstractDataFrame)
    global indicator_cache = df
end

