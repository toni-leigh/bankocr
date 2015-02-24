class Digit
	attr_accessor :integer, :salvage_to, :salvagable, :string, :string_representations, :valid

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
		set_from_string(string) if string.length > 0
	end



	# directly set a Digit using an actual integer
	def set_from_integer(integer)
		@integer = integer
		@string = DIGIT_DATA[@integer]
		@valid = true
		self
	end



	# convert and validate an input string, setting an integer if possible
	def set_from_string(string)
		@string = string
		convert_to_integer
		check_for_errors
	end



	# takes the string and returns an integer and sets valid or not
	def convert_to_integer
		@valid = false
		DIGIT_DATA.each do |integer,data|
			if string == data['string']
				@integer = integer
				@valid = true
			end
		end
	end



	# gets the possible ambiguities for a valid digit from the class constant
	def get_alternates
		DIGIT_DATA[integer]['ambiguities']
	end



	# checks the string characters for errors if it isn't valid, choosing which valid digit
	# the error digit is salvagble to (if any)
	def check_for_errors
		if !valid?
			errors = {}

			DIGIT_DATA.each do |valid_digit_index,valid_digit_data|
				errors[valid_digit_index] = count_comparison_errors(valid_digit_data['string'])
			end

			# no single char error can result in two possible digits so we either find
			# one match with a single error or no matches
			errors.each do |valid_integer,error_count|
				set_salvagable(valid_integer) if error_count === 1
			end
		end
	end



	# counts the number of comparison errors between a self.string and a valid string, returning
	# the number of errors between the two
	def count_comparison_errors(valid_to_compare_to)
		errors = 0

		valid_to_compare_to.split('').each_with_index do |char,index|
			errors += 1 unless char == string.split('')[index]
		end

		errors
	end



	# set whether a digit is salvagable
	def set_salvagable(salvage_to_digit)
		@salvage_to = salvage_to_digit
		@salvagable = true
	end



	# is it salvagable?
	def salvagable?
		salvagable
	end



	# is it valid?
	def valid?
		valid
	end



	# over-ridden to string method
	def to_s
		valid ? "#{integer}" : "?"
	end
end
