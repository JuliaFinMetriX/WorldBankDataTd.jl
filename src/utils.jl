## date handling functions
##------------------------

function getLastDayOfMonth(dt::Date)
    isendofmonth = x -> Dates.lastdayofmonth(x) == x
    Dates.tonext(isendofmonth, dt)
end

function getLastDayOfQuarter(dt::Date)
    quart = Dates.quarterofyear(dt)
    mon, day = 3, 31
    if quart == 2
        mon, day = 6, 30
    elseif quart == 3
        mon, day = 9, 30
    elseif quart == 4
        mon, day = 12, 31
    end
    newDate = Date(year(dt), mon, day)
end

function formatDate(dat::ASCIIString)
    if length(dat) == 4 # yearly data
        newDat = Date(string(dat, "-12-31"))
    else
        # monthly data
        if dat[5] == 'M'
            someDate = Date(string(dat[1:4], "-", dat[6:7], "-01"))
            newDat = getLastDayOfMonth(someDate)

            ## quaterly data
        elseif dat[5:6] == "Q1"
            someDate = Date(string(dat[1:4], "-01-01"))
            newDat = getLastDayOfQuarter(someDate)
        elseif dat[5:6] == "Q2"
            someDate = Date(string(dat[1:4], "-04-01"))
            newDat = getLastDayOfQuarter(someDate)
        elseif dat[5:6] == "Q3"
            someDate = Date(string(dat[1:4], "-07-01"))
            newDat = getLastDayOfQuarter(someDate)
        elseif dat[5:6] == "Q4"
            someDate = Date(string(dat[1:4], "-10-01"))
            newDat = getLastDayOfQuarter(someDate)
        end
    end
    return newDat
end

## database style select functions
##--------------------------------

import Base.get
function get(df::DataFrame, sb::Symbol, f::Function)
    ## pick observation based on single entry in row
    nObs, nVars = size(df)
    logInd = Array(Bool, nObs)
    for ii=1:nObs
        logInd[ii] = f(df[sb][ii])
    end
    return df[logInd, :]
end

function get(df::DataFrame, f::Function)
    ## pick observation based on complete row
    nObs, nVars = size(df)
    logInd = Array(Bool, nObs)
    for ii=1:nObs
        logInd[ii] = f(df[ii, :])
    end
    return df[logInd, :]
end

## conversion functions
##---------------------

function tofloat(f::String)
     try
         return float(f)
     catch
         return NA
     end
end

function tofloat(Void)
    return NA
end

function clean_and_push!(da::DataArray, Void)
    push!(da, NA)
end

function clean_and_push!(da::DataArray, x::String)
    if (x == "NA") | (x == "")
        push!(da, NA)
    else
        push!(da, x)
    end
end

## function clean_entry(x::Union(String,Nothing))
##     if typeof(x) == Nothing # also equals Void
##         return "NA"
##     else
##         return x
##     end
## end

## function clean_append!(vals::Union(Array{UTF8String,1},Array{ASCIIString,1}),val::Union(UTF8String,ASCIIString,Nothing))
##     append!(vals,[clean_entry(val)])
## end

