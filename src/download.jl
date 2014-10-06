# example:
#   df=wdi("NY.GNP.PCAP.CD", ["US","BR"], 1980, 2012, true)
function wdi(indicators::Union(ASCIIString,Array{ASCIIString,1}),
             countries::Union(ASCIIString,Array{ASCIIString,1}),
             startyear::Integer=1800,endyear::Integer=3000,
             extra::Bool=false)
    ## download multiple indicators / countries
    if countries == "all"
        countries = all_countries
    end

    if typeof(countries) == ASCIIString
        countries = [countries]
    end

    for c in countries
        if ! (c in all_countries)
            error("country ",c," not found")
        end
    end

    if ! (startyear < endyear)
        error("startyear has to be < endyear. startyear=",startyear,". endyear=",endyear)
    end

    df = DataFrame()

    if typeof(indicators) == ASCIIString
        indicators=[indicators]
    end

    for ind in indicators
        dfn = wdi_download(ind, countries, startyear, endyear)
        df = vcat(df,dfn)
    end

    if extra
        cntdat = get_countries()
        df = join(df, cntdat, on = :iso2c)
    end

    df
end

function wdi_download(indicator::ASCIIString,
                      country::Union(ASCIIString,Array{ASCIIString,1}),
                      startyear::Integer,
                      endyear::Integer)
    # download single indicator for possibly multiple countries and
    # years 
    if typeof(country) == ASCIIString # single country
        countryString = country
    else
        countryString = join(country, ";")
    end
        
    url = string("http://api.worldbank.org/countries/", countryString, "/indicators/", indicator,
                 "?date=", startyear,":", endyear, "&per_page=25000", "&format=json")
    json = [download_parse_json(url)[2]]
    
    ## elseif typeof(country) == Array{ASCIIString,1} # iterate over
    ##                                     # countries 
    ##     json = Any[]
    ##     for c in country
    ##         url = string("http://api.worldbank.org/countries/", c, "/indicators/", indicator,
    ##                      "?date=", startyear,":", endyear, "&per_page=25000", "&format=json")
    ##         append!(json,[download_parse_json(url)[2]])
    ##     end
    ## end

    parse_wdi(indicator,json, startyear, endyear)
end

function download_parse_json(url::ASCIIString)
    ## try to download data and process JSON to Dict
    println("download: ",url)
    request = HTTPC.get(url)
    if request.http_code != 200
        error("download failed")
    end
    JSON.parse(bytestring(request.body))
end

function parse_wdi(indicator::ASCIIString, json, startyear::Integer,
                   endyear::Integer) 
    country_id = ASCIIString[]
    country_name = UTF8String[]
    value = ASCIIString[]
    date = ASCIIString[]

    for d in json
        clean_append!(country_id,d["country"]["id"]) # iso-2 
        clean_append!(country_name,d["country"]["value"]) # name 
        clean_append!(value,d["value"])
        clean_append!(date,d["date"])
    end

    value = [tofloat(ii) for ii in value]
    ## value = float64(DataArray(Any[tofloat(i) for i in value]))
    date = Date[formatDate(dat) for dat in date]
    ## Date[Date(string(ii, "-12-31")) for ii in date]
    ## date = float64(DataArray(Any[tofloat(i) for i in date]))

    df = DataFrame(iso2c = country_id, country = country_name)
    df[symbol(indicator)] = value
    df[:time] = date

    # filter missing/wrong data
    complete_cases!(df)

    startY = formatDate(string(startyear))
    endY = formatDate(string(endyear))
    checkyear(x) = (x >= startY) & (x <= endY)
    yind = map(checkyear,df[:time])
    yind = convert(DataArray{Bool, 1}, yind)
    df[yind, :]
end


function clean_entry(x::Union(String,Nothing))
    if typeof(x) == Nothing
        return "NA"
    else
        return x
    end
end

function clean_append!(vals::Union(Array{UTF8String,1},Array{ASCIIString,1}),val::Union(UTF8String,ASCIIString,Nothing))
    append!(vals,[clean_entry(val)])
end

all_countries = ["AW","AF","A9","AO","AL","AD","L5","1A","AE","AR","AM","AS","AG","AU","AT","AZ","BI","BE","BJ","BF","BD","BG","BH","BS","BA","BY","BZ","BM","BO","BR","BB","BN","BT","BW","C9","CF","CA","C4","B8","C5","CH","JG","CL","CN","CI","C6","C7","CM","CD","CG","CO","KM","CV","CR","C8","S3","CU","CW","KY","CY","CZ","DE","DJ","DM","DK","DO","DZ","4E","Z4","7E","Z7","EC","EG","XC","ER","ES","EE","ET","EU","F1","FI","FJ","FR","FO","FM","GA","GB","GE","GH","GN","GM","GW","GQ","GR","GD","GL","GT","GU","GY","XD","HK","HN","XE","HR","HT","HU","ID","IM","IN","XY","IE","IR","IQ","IS","IL","IT","JM","JO","JP","KZ","KE","KG","KH","KI","KN","KR","KV","KW","XJ","LA","LB","LR","LY","LC","ZJ","L4","XL","XM","LI","LK","XN","XO","LS","LT","LU","LV","MO","MF","MA","L6","MC","MD","MG","MV","ZQ","MX","MH","XP","MK","ML","MT","MM","XQ","ME","MN","MP","MZ","MR","MU","MW","MY","XU","M2","NA","NC","NE","NG","NI","NL","XR","NO","NP","NZ","XS","OE","OM","S4","PK","PA","PE","PH","PW","PG","PL","PR","KP","PT","PY","PS","S2","PF","QA","RO","RU","RW","8S","SA","L7","SD","SN","SG","SB","SL","SV","SM","SO","RS","ZF","SS","ZG","S1","ST","SR","SK","SI","SE","SZ","SX","A4","SC","SY","TC","TD","TG","TH","TJ","TM","TL","TO","TT","TN","TR","TV","TZ","UG","UA","XT","UY","US","UZ","VC","VE","VI","VN","VU","1W","WS","A5","YE","ZA","ZM","ZW"]

## all_countries = ["AW", "AF", "A9", "AO", "AL", "AD", "1A", "AE", "AR", "AM", "AS", "AG", "AU", "AT", "AZ", "BI", "BE", "BJ", "BF", "BD", "BG", "BH", "BS", "BA", "BY", "BZ", "BM", "BO", "BR", "BB", "BN", "BT", "BW", "C9", "CF", "CA", "C4", "C5", "CH", "JG", "CL", "CN", "CI", "C6", "C7", "CM", "CD", "CG", "CO", "KM", "CV", "CR", "C8", "S3", "CU", "CW", "KY", "CY", "CZ", "DE", "DJ", "DM", "DK", "DO", "DZ", "4E", "Z4", "7E", "Z7", "EC", "EG", "XC", "ER", "ES", "EE", "ET", "EU", "FI", "FJ", "FR", "FO", "FM", "GA", "GB", "GE", "GH", "GN", "GM", "GW", "GQ", "GR", "GD", "GL", "GT", "GU", "GY", "XD", "HK", "HN", "XE", "HR", "HT", "HU", "ID", "IM", "IN", "XY", "IE", "IR", "IQ", "IS", "IL", "IT", "JM", "JO", "JP", "KZ", "KE", "KG", "KH", "KI", "KN", "KR", "KV", "KW", "XJ", "LA", "LB", "LR", "LY", "LC", "ZJ", "XL", "XM", "LI", "LK", "XN", "XO", "LS", "LT", "LU", "LV", "MO", "MF", "MA", "MC", "MD", "MG", "MV", "ZQ", "MX", "MH", "XP", "MK", "ML", "MT", "MM", "XQ", "ME", "MN", "MP", "MZ", "MR", "MU", "MW", "MY", "XU", "M2", "NA", "NC", "NE", "NG", "NI", "NL", "XR", "NO", "NP", "NZ", "XS", "OE", "OM", "S4", "PK", "PA", "PE", "PH", "PW", "PG", "PL", "PR", "KP", "PT", "PY", "PS", "S2", "PF", "QA", "RO", "RU", "RW", "8S", "SA", "SD", "SN", "SG", "SB", "SL", "SV", "SM", "SO", "RS", "ZF", "SS", "ZG", "S1", "ST", "SR", "SK", "SI", "SE", "SZ", "SX", "A4", "SC", "SY", "TC", "TD", "TG", "TH", "TJ", "TM", "TL", "TO", "TT", "TN", "TR", "TV", "TZ", "UG", "UA", "XT", "UY", "US", "UZ", "VC", "VE", "VI", "VN", "VU", "1W", "WS", "A5", "YE", "ZA", "ZM", "ZW" ]


