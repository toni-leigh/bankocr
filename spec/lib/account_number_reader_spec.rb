require "spec_helper"
require "account_number_reader"

describe AccountNumberReader do

	before { subject.read_numbers_file }

	it "should read the file from source into memory" do

		expect ( subject.account_numbers_string.length ).to be > 0

	end

	xit "should create account number objects" do

	end

	xit "should create a number of account numbers which is one quarter of the number of lines in the file" do

	end

end