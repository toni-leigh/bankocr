class Digit
	attr_accessor :number, :string

	@@string_representations = {
		' _ | ||_|' => 0,
		'     |  |' => 1,
		' _   ||_ ' => 2,
		' _  _| _|' => 3,
		'   |_|  |' => 4,
		' _ |_  _|' => 5,
		' _ |_ |_|' => 6,
		' _   |  |' => 7,
		' _ |_||_|' => 8,
		' _ |_| _|' => 9
	}

	def self.get_string_representations
		@@string_representations
	end

	def initialize(string = '')
		@number = 1
		@string = string
	end

	def convert_to_integer
		@@string_representations[@string]
	end
end