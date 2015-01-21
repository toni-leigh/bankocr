require "spec_helper"
require "account_number_reader"

describe AccountNumberReader do

	it "should read the file from source into memory as a string" do

		subject.read_numbers_file

		expect( IO.read(subject.account_numbers_source).length ).to be > 0

		expect( subject.account_numbers_string ).to be_kind_of (String)

		expect( subject.account_numbers_string.length ).to be > 0

	end

	it "should create account number objects" do

		subject.create_account_number_collection

		expect( subject.account_numbers ).to be_kind_of (Array)

		expect( subject.account_numbers.length ).to be > 0

		expect ( subject.account_numbers_string.lines ).to be == subject.account_numbers.length * 4

	end

end