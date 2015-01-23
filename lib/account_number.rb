class AccountNumber

	attr_accessor :account_number_string, :alternate_numbers, :digits, :salvagable, :valid

	def initialize(account_number_string = '')

		@account_number_string = account_number_string

		@humanised_output = ''

		@digits = Array.new(9)

		@alternate_numbers = []

		convert_account_number

		validate

	end

	def convert_account_number

		@digits.each_with_index do |digit,index|

			@digits[index] = Digit.new(retrieve_digit_string(index))

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

		@legible = true

		count_illegible = 0

		@salvagable = true

		(0..8).each do |i|
			if @digits[8-i].number == nil
				count_illegible += 1
				@legible = false
			else
 				checksum += (@digits[8-i].number*(i+1))
 			end
		end

		@salvagable = false unless count_illegible < 2

		@valid = ( checksum % 11 == 0 )

	end

	def valid?
		@valid 
	end

	def legible?
		@legible 
	end

	def salvagable?
		@salvagable 
	end

	def to_s 

		output_string = ''

		@digits.each do |digit|

			output_string += "#{digit.to_s}"

		end

		if @legible
			output_string += ' ERR' unless @valid
		else
			output_string += ' ILL'
		end

		output_string

	end

end