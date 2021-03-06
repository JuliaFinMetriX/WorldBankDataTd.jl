module TestParseWDI

using Base.Test
using WorldBankDataTd
using Dates

us_gnp_data = {  { "total"=>23,"per_page"=>"25000","pages"=>1,"page"=>1 },
                 { ["date"=>"2012","value"=>"52340","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"],
                   ["date"=>"2011","value"=>"50650","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"],
                   ["date"=>"2010","value"=>"48960","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"],
                   ["date"=>"2009","value"=>"48040","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"],
                   ["date"=>"2008","value"=>"49350","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"],
                   ["date"=>"2007","value"=>"48640","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"],
                   ["date"=>"2006","value"=>"48080","indicator"=>["id"=>"NY.GNP.PCAP.CD","value"=>"GNI per capita, Atlas method (current US\$)"],"country"=>["id"=>"US","value"=>"United States"],"decimal"=>"0"]
                 }
              }

us_gnp = WorldBankDataTd.parse_wdi("NY.GNP.PCAP.CD",us_gnp_data[2],2006,2012)

@test us_gnp[:time] == Date[Date(2012,12,31), Date(2011,12,31),
                            Date(2010,12,31), Date(2009,12,31),
                            Date(2008,12,31), Date(2007,12,31),
                            Date(2006,12,31)]
                            
@test us_gnp[symbol("NY.GNP.PCAP.CD")] == Float64[52340, 50650, 48960, 48040, 49350, 48640, 48080]

end
