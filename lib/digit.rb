class Digit
	attr_accessor :number, :salvage_to, :salvagable, :string, :string_representations, :valid

	DIGIT_DATA = {
		0 => { 'string' => ' _ | ||_|', 'ambiguities' => [8] },
		1 => { 'string' => '     |  |', 'ambiguities' => [7] },
		2 => { 'string' => ' _  _||_ ', 'ambiguities' => [] },
		3 => { 'string' => ' _  _| _|', 'ambiguities' => [9] },
		4 => { 'string' => '   |_|  |', 'ambiguities' => [] },
		5 => { 'string' => ' _ |_  _|', 'ambiguities' => [6,9] },
		6 => { 'string' => ' _ |_ |_|', 'ambiguities' => [5,8] },
		7 => { 'string' => ' _   |  |', 'ambiguities' => [1] },
		8 => { 'string' => ' _ |_||_|', 'ambiguities' => [0,6,9] },
		9 => { 'string' => ' _ |_| _|', 'ambiguities' => [3,5,8] }
	}

	def initialize(string = '')
		@salvagable = false
		if (string.length > 0)
			set_from_string(string)
		end
	end

	def set_from_integer(integer)
		@number = integer
		@string = DIGIT_DATA[@number]
		@valid = true
		self
	end

	def set_from_string(string)
		@string = string
		convert_to_integer
		check_for_errors		
	end

	def convert_to_integer
		@valid = false
		DIGIT_DATA.each do |integer,data|
			if (@string == data['string'])
				@number = integer
				@valid = true
			end
		end
	end

	def get_alternates
		DIGIT_DATA[@number]['ambiguities']
	end

	def check_for_errors	
		if (!valid?)
			errors = {}

			DIGIT_DATA.each do |valid_digit_index,valid_digit_data|
				errors[valid_digit_index] = count_comparison_errors(valid_digit_data['string'])
			end

			# no single char error can result in two possible digits so we either find
			# one match with a single error or no matches
			errors.each do |valid_integer,error_count|
				if error_count === 1
					set_salvagable(valid_integer)
				end
			end
		end
	end

	def count_comparison_errors(valid_to_compare_to)
		errors = 0

		valid_to_compare_to.split('').each_with_index do |char,index|
			errors += 1 unless char == @string.split('')[index]
		end

		errors
	end

	def set_salvagable(salvage_to_digit)
		@salvage_to = salvage_to_digit
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