class Digit
	attr_accessor :number, :string, :string_representations

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

	def initialize(string = '')
		@string = string
		@number = convert_to_integer
	end

	def convert_to_integer
		VALID_STRING_REPRESENTATIONS[@string]
	end
end