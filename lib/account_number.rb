class AccountNumber

	attr_accessor :account_number_string, :digits, :humanised_output

	def initialize(account_number_string = '')

		@account_number_string = account_number_string

		@humanised_output = ''

		@digits = Array.new(9)

		convert_account_number

	end

	def convert_account_number

		@digits.each_with_index do |digit,index|

			@digits[index] = Digit.new(retrieve_digit_string(index))

			@humanised_output += "#{@digits[index].number}"

		end

	end

	def retrieve_digit_string(position)

		[ 
			@account_number_string[position * 3,3],
			@account_number_string[position * 3 + 27,3],
			@account_number_string[position * 3 + 54,3]
		].join('')

	end

end