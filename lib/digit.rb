class Digit
	attr_accessor :number, :string, :string_representations, :valid

	VALID_STRING_REPRESENTATIONS = {
		' _ | ||_|' => 0,
		'     |  |' => 1,
		' _  _||_ ' => 2,
		' _  _| _|' => 3,
		'   |_|  |' => 4,
		' _ |_  _|' => 5,
		' _ |_ |_|' => 6,
		' _   |  |' => 7,
		' _ |_||_|' => 8,
		' _ |_| _|' => 9
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
		@string = string
		@number = convert_to_integer
	end

	def convert_to_integer
		@valid = false
		if VALID_STRING_REPRESENTATIONS[@string] then
			@valid = true
		end
		VALID_STRING_REPRESENTATIONS[@string]
	end

	def get_alternates(target = nil)
		AMBIGUOUS_DIGITS[target]
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