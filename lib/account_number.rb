class AccountNumber

	attr_accessor :account_number_string, :digits, :humanised_output, :valid

	def initialize(account_number_string = '')

		@account_number_string = account_number_string

		@humanised_output = ''

		@digits = Array.new(9)

		convert_account_number

		validate

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

	def validate

		checksum = 0;

		(0..8).each do |i|
 			checksum += (@digits[8-i].number*(i+1))
		end

		@valid = ( checksum % 11 == 0 )

	end

	def valid?
		@valid 
	end

end