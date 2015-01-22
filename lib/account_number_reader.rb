class AccountNumberReader

	attr_accessor :account_numbers_string, :account_numbers_source, :account_numbers

	ACCOUNT_NUMBER_LINE_COUNT = 4

	def initialize(account_numbers_source = 'data/use_case_1.txt')

		@account_numbers_source = account_numbers_source

		@account_numbers = []

		read_numbers_file

		create_account_number_collection

	end

	def read_numbers_file

		@account_numbers_string = IO.read(account_numbers_source)
		
	end

	def create_account_number_collection

		account_number_string = ''

		@account_numbers_string.lines.to_a.each_with_index do |line,index|

			account_number_string += line.chomp
			
			if (index % ACCOUNT_NUMBER_LINE_COUNT == (ACCOUNT_NUMBER_LINE_COUNT - 1)) then				

				@account_numbers << AccountNumber.new(account_number_string)

				account_number_string = ''

			end

		end

	end

end