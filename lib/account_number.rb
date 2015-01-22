class AccountNumber

	attr_accessor :account_number_string, :digits

	def initialize(account_number_string = '')

		@account_number_string = account_number_string

		@digits = Array.new(9)

		@digits.each_with_index do |digit,index|
			@digits[index] = Digit.new
		end

	end

end