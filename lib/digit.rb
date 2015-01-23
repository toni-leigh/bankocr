class Digit
	attr_accessor :number, :string, :string_representations, :valid

	VALID_STRING_REPRESENTATIONS = {
		' * * ****' => 0,
		'     *  *' => 1,
		' *  **** ' => 2,
		' *  ** **' => 3,
		'   ***  *' => 4,
		' * **  **' => 5,
		' * ** ***' => 6,
		' *   *  *' => 7,
		' * ******' => 8,
		' * *** **' => 9
	}

	AMBIGUOUS_DIGITS = [
		0 => [8],
		1 => [7],
		3 => [9],
		5 => [6,9],
		6 => [5,8],
		7 => [1],
		8 => [0,6,9],
		9 => [3,5,8]
	]

	def initialize(string = '')
		@string = string.gsub(/[|_]/,'*')
		@number = convert_to_integer
	end

	def convert_to_integer
		@valid = false
		if VALID_STRING_REPRESENTATIONS[@string] then
			@valid = true
		end
		VALID_STRING_REPRESENTATIONS[@string]
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