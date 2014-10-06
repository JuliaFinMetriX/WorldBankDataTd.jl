module TestUtils

using Base.Test
using Base.Dates
using WorldBankData

## last day of month
##------------------

expOut = Date(2014, 9, 30)
actOut = WorldBankData.getLastDayOfMonth(Date(2014, 9))
@test expOut == actOut

expOut = Date(2014, 3, 31)
actOut = WorldBankData.getLastDayOfMonth(Date(2014, 3))
@test expOut == actOut

## last day of quarter
##--------------------

expOut = Date(2014, 3, 31)
actOut = WorldBankData.getLastDayOfQuarter(Date(2014))
@test expOut == actOut

expOut = Date(2014, 9, 30)
actOut = WorldBankData.getLastDayOfQuarter(Date(2014, 7))
@test expOut == actOut

expOut = Date(2014, 9, 30)
actOut = WorldBankData.getLastDayOfQuarter(Date(2014, 9, 30))
@test expOut == actOut

## convert dates to Date type
##---------------------------

@test Date(2014, 12, 31) == WorldBankData.formatDate("2014")
@test Date(2014, 3, 31) == WorldBankData.formatDate("2014Q1")
@test Date(2014, 9, 30) == WorldBankData.formatDate("2014Q3")
@test Date(2014, 3, 31) == WorldBankData.formatDate("2014M03")
@test Date(2014, 9, 30) == WorldBankData.formatDate("2014M09")

end
