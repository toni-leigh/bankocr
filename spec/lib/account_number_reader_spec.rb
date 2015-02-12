require "spec_helper"
require "account_number_reader"

describe AccountNumberReader do
	
	it "should read the file from source into memory as a string" do
		expect( IO.read(subject.account_numbers_source).length ).to be > 0
		expect( subject.account_numbers_string ).to be_kind_of (String)
		expect( subject.account_numbers_string.length ).to be > 0
	end

	it "should create account number objects" do
		expect( subject.account_numbers ).to be_kind_of (Array)
		expect( subject.account_numbers.length ).to be > 0
		# this test checks the resulting number of account numbers reflects the number expected from the file size
		expect( subject.account_numbers_string.lines.to_a.length ).to be == subject.account_numbers.length * 4
	end

end