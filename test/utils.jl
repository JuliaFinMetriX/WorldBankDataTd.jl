module TestUtils

using Base.Test
using DataFrames
using WorldBankDataTd
using Dates

## last day of month
##------------------

expOut = Date(2014, 9, 30)
actOut = WorldBankDataTd.getLastDayOfMonth(Date(2014, 9))
@test expOut == actOut

expOut = Date(2014, 3, 31)
actOut = WorldBankDataTd.getLastDayOfMonth(Date(2014, 3))
@test expOut == actOut

## last day of quarter
##--------------------

expOut = Date(2014, 3, 31)
actOut = WorldBankDataTd.getLastDayOfQuarter(Date(2014))
@test expOut == actOut

expOut = Date(2014, 9, 30)
actOut = WorldBankDataTd.getLastDayOfQuarter(Date(2014, 7))
@test expOut == actOut

expOut = Date(2014, 9, 30)
actOut = WorldBankDataTd.getLastDayOfQuarter(Date(2014, 9, 30))
@test expOut == actOut

## convert dates to Date type
##---------------------------

@test Date(2014, 12, 31) == WorldBankDataTd.formatDate("2014")
@test Date(2014, 3, 31) == WorldBankDataTd.formatDate("2014Q1")
@test Date(2014, 9, 30) == WorldBankDataTd.formatDate("2014Q3")
@test Date(2014, 3, 31) == WorldBankDataTd.formatDate("2014M03")
@test Date(2014, 9, 30) == WorldBankDataTd.formatDate("2014M09")

## conversion to float
##--------------------

@test isequal(WorldBankDataTd.tofloat("NA"), NA)
@test WorldBankDataTd.tofloat("1.23") == 1.23
@test isequal(WorldBankDataTd.tofloat(Void), NA)
@test isequal(WorldBankDataTd.tofloat(Nothing), NA)

## appending to DataArray
##-----------------------

### push Void

da = @data(["one", NA, "two"])
expDa = @data(["one", NA, "two", NA])

WorldBankDataTd.clean_and_push!(da, Void)
@test isequal(da, expDa)

### push ""

da = @data(["one", NA, "two"])
expDa = @data(["one", NA, "two", NA])

WorldBankDataTd.clean_and_push!(da, "")
@test isequal(da, expDa)

### push "NA"

da = @data(["one", NA, "two"])
expDa = @data(["one", NA, "two", NA])

WorldBankDataTd.clean_and_push!(da, "NA")
@test isequal(da, expDa)


end
