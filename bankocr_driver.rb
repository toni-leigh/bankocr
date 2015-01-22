require "./lib/account_number_reader.rb"
require "./lib/account_number.rb"
require "./lib/digit.rb"

account_number_reader = AccountNumberReader.new()
puts account_number_reader.account_numbers.length
account_number_reader.account_numbers.each do |acc_num|
	puts acc_num.humanised_output
end
