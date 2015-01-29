class AccountNumber

	attr_accessor :account_number_length, :account_number_string, :alternate_numbers, :salvagable, :ambiguous, :digits, :valid

	def initialize(account_number_string = '', account_number_length = 9)
		@account_number_length = account_number_length
		@digits = Array.new(@account_number_length)
		@alternate_numbers = []		
		@alternate = false
		@account_number_string = account_number_string
		@ambiguous = false
		@salvagable = false

		if (account_number_string.length > 0)
			set_from_string
		end

	end

	# is the account number invlid but have more than one valid alternative
	# set looks at the count of alternate numbers
	def ambiguous?
		@ambiguous
	end

	def set_ambiguous
		if (@alternate_numbers.length > 1)
			@ambiguous = true
		end
	end

	# does the account number pass the checksum validation
	# set performs checksum
	def valid?
		@valid 
	end

	def validate
		checksum = 0;

		(0..(@account_number_length - 1)).each do |i|
			if @digits[(@account_number_length - 1)-i].number != nil
 				checksum += (@digits[(@account_number_length - 1)-i].number*(i+1))
 			end
		end

		@valid = ( checksum % 11 == 0 )
	end

	# is the account number salvagable? i.e. does it have error digit with 
	# just one error in the digit itself
	# set checks Digit.salvagbale status and also makes sure just one Digit
	# is invalid
	def salvagable?
		@salvagable 
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
		if count_salvagables == 1 && count_valids == (@account_number_length - 1)
			@salvagable = true
		end
	end

	# is the account number legible, are all digits readable? An account 
	# number can be illegible and salvagable, or illegible and not salvagable
	def legible?
		@legible 
	end

	def set_legible
		@legible = true

		(0..(@account_number_length - 1)).each do |i|
			if @digits[(@account_number_length - 1)-i].number == nil
				@legible = false
 			end
		end
	end

	# looks at the account number string and extracts the 3x3 charset that
	# respresents the digit
	#
	# position - Integer that represents the position, 0 - (@account_number_length - 1) to target
	# 
	# return - @account_number_length char string that represents the digit
	def get_digit_string(position)
		[ 
			@account_number_string[position * 3,3],
			@account_number_string[position * 3 + (@account_number_length * 3),3],
			@account_number_string[position * 3 + (@account_number_length * 3 * 2),3]
		].join('')
	end

	# builds an alternate integer array - used for ambiguous account numbers
	# 
	def get_alternate_integer_array(new_digit,target_index)
		integer_array = []

		@digits.each do |digit|
			integer_array << digit.number
		end

		integer_array[target_index] = new_digit

		integer_array
	end

	# sets up the Digit array based on the string input and validates
	def set_from_string
		@digits.each_with_index do |digit,index|
			@digits[index] = Digit.new(get_digit_string(index))
		end

		validate
		set_legible

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

	# sets up the Digit array based on an array of Integers, which skips
	# the validations for legibility and salvagability
	def set_from_integers(integer_array)
		integer_array.each_with_index do |integer,index|
			@digits[index] = Digit.new;
			@digits[index].set_from_integer(integer)
		end
		validate
		set_legible
	end

	# looks through the account number and builds alternate numbers, using ambiguous
	# digits, adding them to the alternate numbers arrays
	def set_alternates 
		@digits.each_with_index do |digit,index|
			digit.get_alternates.to_a.each do |alternate_digit|
				alternate_integer_array = get_alternate_integer_array(alternate_digit,index)
				add_new_alternate(alternate_integer_array)
			end
		end

		set_ambiguous
	end

	# builds an integer array from a salvagble number storing it as an alternate
	def salvage_number
		alternate_integer_array = []
		@digits.each_with_index do |digit,index|
			if (digit.valid?)
				alternate_integer_array[index] = digit.number
			else
				alternate_integer_array[index] = digit.salvage_to
			end
		end
		add_new_alternate(alternate_integer_array)
	end

	# creates a new AccountNumber object and adds that to the alternate numbers 
	# array if it is valid
	def add_new_alternate(alternate_integer_array)
		alternate_account_number = AccountNumber.new
		alternate_account_number.set_from_integers(alternate_integer_array)

		if (alternate_account_number.valid?)
			@alternate_numbers << alternate_account_number
		end
	end

	# if there is one alternate then apply it else do nothing
	# also an applied alternate is valid and legible
	def apply_alternate
		if (@alternate_numbers.length == 1)
			@digits = @alternate_numbers[0].digits
			@valid = true
			@legible = true
		end
	end

	def to_s 
		output_string = ''

		@digits.each do |digit|
			output_string += "#{digit.to_s}"
		end

		output_string += if @ambiguous
			' AMB'
		else
			if @legible 
				if !@valid
					' ERR'
				else
					''
				end
			else
				' ILL'
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