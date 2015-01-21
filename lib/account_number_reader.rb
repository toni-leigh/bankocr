class AccountNumberReader

	attr_accessor :account_numbers_string, :account_numbers_source

	def initialize(account_numbers_source = 'data/use_case_1.txt')

		@account_numbers_source = account_numbers_source

	end

	def read_numbers_file
		
	end

end