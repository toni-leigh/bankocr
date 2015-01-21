require "spec_helper"
require "account_number_reader"

describe AccountNumberReader do

	before { subject.read_numbers_file }

	it "should read the file from source into memory as a string" do

		expect( IO.read(subject.account_numbers_source) ).to be > 0

		expect( subject.account_numbers_string ).to be_kind_of (String)

		expect( subject.account_numbers_string.length ).to be > 0

	end

	xit "should create account number objects" do

	end

	xit "should create a number of account numbers which is one quarter of the number of lines in the file" do

	end

end