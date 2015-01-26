class Digit
	attr_accessor :number, :salvage, :salvagable, :string, :string_representations, :valid

	VALID_STRING_REPRESENTATIONS = {
		0 => ' _ | ||_|',
		1 => '     |  |',
		2 => ' _  _||_ ',
		3 => ' _  _| _|',
		4 => '   |_|  |',
		5 => ' _ |_  _|',
		6 => ' _ |_ |_|',
		7 => ' _   |  |',
		8 => ' _ |_||_|',
		9 => ' _ |_| _|'
	}

	AMBIGUOUS_DIGITS = {
		0 => [8],
		1 => [7],
		3 => [9],
		5 => [6,9],
		6 => [5,8],
		7 => [1],
		8 => [0,6,9],
		9 => [3,5,8]
	}

	def initialize(string = '')
		@salvagable = false
		if (string.length > 0)
			set_from_string(string)
		end
	end

	def set_from_string(string)
		@string = string
		convert_to_integer
		check_for_errors		
	end

	def convert_to_integer
		@valid = false
		VALID_STRING_REPRESENTATIONS.each do |integer,string_representation|
			if (@string == string_representation)
				@number = integer
				@valid = true
			end
		end
	end

	def get_alternates(target = nil)
		AMBIGUOUS_DIGITS[target]
	end

	def check_for_errors		
		errors = {}

		VALID_STRING_REPRESENTATIONS.each do |valid_digit_index,valid_digit_string|
			errors[valid_digit_index] = count_comparison_errors(valid_digit_string)
		end

		# no single char error can result in two possible digits so we either find
		# one match with a single error or no matches
		errors.each do |valid_digit_string,error_count|
			if error_count === 1
				set_salvagable(valid_digit_string)
			end
		end
	end

	def count_comparison_errors(valid_to_compare_to)
		errors = 0

		valid_to_compare_to.split('').each_with_index do |char,index|
			if char == @string.split('')[index]
			else
				errors += 1
			end
		end

		errors
	end

	def set_salvagable(salvage_to_digit)
		@salvage = salvage_to_digit
		@salvagable = true
	end

	def salvagable?
		@salvagable
	end

	def valid?
		@valid
	end

	def to_s
		if @valid then
			"#{@number}"
		else
			"?"
		end
	end
end