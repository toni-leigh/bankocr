class AccountNumberReader

	attr_accessor :account_numbers_string, :account_numbers_source, :account_numbers

	def initialize(account_numbers_source = 'data/use_case_1.txt')

		@account_numbers_source = account_numbers_source

		@account_numbers = []

	end

	def read_numbers_file

		@account_numbers_string = IO.read(account_numbers_source)
		
	end

	def create_account_number_collection

	end

end