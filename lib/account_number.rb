class AccountNumber

	attr_accessor :account_number_string, :alternate_numbers, :salvagable, :ambiguous, :digits, :valid

	def initialize(account_number_string = '')
		@digits = Array.new(9)
		@alternate_numbers = []		
		@alternate = false
		@account_number_string = account_number_string
		@ambiguous = false
		@salvagable = false

		if (account_number_string.length > 0)
			set_from_string
		end

	end

	def ambiguous?
		@ambiguous
	end

	def valid?
		@valid 
	end

	def salvagable?
		@salvagable 
	end

	def legible?
		@legible 
	end

	def get_digit_string(position)
		[ 
			@account_number_string[position * 3,3],
			@account_number_string[position * 3 + 27,3],
			@account_number_string[position * 3 + 54,3]
		].join('')
	end

	def get_alternate_integer_array(new_digit,target_index)
		integer_array = []

		@digits.each do |digit|
			integer_array << digit.number
		end

		integer_array[target_index] = new_digit

		integer_array
	end

	def set_from_string
		@digits.each_with_index do |digit,index|
			@digits[index] = Digit.new(get_digit_string(index))
		end

		validate

		set_salvagable unless legible?

		if (legible? && !valid?)
			set_alternates
			apply_alternate
		end

		if (salvagable?)
			salvage_number
			apply_alternate
		end
	end

	def set_from_integers(integer_array)
		integer_array.each_with_index do |integer,index|
			@digits[index] = Digit.new;
			@digits[index].set_from_integer(integer)
		end
	end

	def set_alternates 
		@digits.each_with_index do |digit,index|
			digit.get_alternates.to_a.each do |alternate_digit|
				alternate_integer_array = get_alternate_integer_array(alternate_digit,index)
				alternate_account_number = AccountNumber.new
				alternate_account_number.set_from_integers(alternate_integer_array)

				if (alternate_account_number.validate)
					@alternate_numbers << alternate_account_number
				end
			end
		end

		set_ambiguous
	end

	def set_ambiguous
		if (@alternate_numbers.length > 1)
			@ambiguous = true
		end
	end

	def set_salvagable
		count_salvagables = 0
		count_valids = 0
		@digits.each do |digit|
			if (digit.salvagable?)
				count_salvagables += 1
			end
			if (digit.valid?)
				count_valids += 1
			end
		end
		# counting one salvagable isn't enough, need eight valids for it to be a truly salvagable
		# acc number
		if count_salvagables == 1 && count_valids == 8
			@salvagable = true
		end
	end

	def salvage_number
		alternate_integer_array = []
		@digits.each_with_index do |digit,index|
			if (digit.valid?)
				alternate_integer_array[index] = digit.number
			else
				alternate_integer_array[index] = digit.salvage_to
			end
		end
		alternate_account_number = AccountNumber.new
		alternate_account_number.set_from_integers(alternate_integer_array)

		if (alternate_account_number.validate)
			@alternate_numbers << alternate_account_number
		end
	end

	def apply_alternate
		if (@alternate_numbers.length == 1)
			@digits = @alternate_numbers[0].digits
			@valid = true
			@legible = true
		end
	end

	def validate
		checksum = 0;
		@legible = true

		(0..8).each do |i|
			if @digits[8-i].number == nil
				@legible = false
			else
 				checksum += (@digits[8-i].number*(i+1))
 			end
		end

		@valid = ( checksum % 11 == 0 )
	end

	def to_s 
		output_string = ''

		@digits.each do |digit|
			output_string += "#{digit.to_s}"
		end

		if @ambiguous
			output_string += ' AMB'
		else
			if @legible
				output_string += ' ERR' unless @valid
			else
				output_string += ' ILL'
			end
		end

		alternates = []
		if (@alternate_numbers.length > 1)
			output_string += ' ['
			@alternate_numbers.each do |alternate|
				alternates << alternate.to_s
			end
			output_string += alternates.join(', ')
			output_string += ']'
		end

		output_string
	end
end