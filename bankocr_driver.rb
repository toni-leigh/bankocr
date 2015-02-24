require "./lib/account_number_reader"
require "./lib/account_number"
require "./lib/digit"

account_number_reader = AccountNumberReader.new()
puts account_number_reader.account_numbers.length
account_number_reader.account_numbers.each do |acc_num|
  puts acc_num.to_s
end
