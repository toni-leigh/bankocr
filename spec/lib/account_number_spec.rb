require "spec_helper"
require "account_number"

describe AccountNumber do

	let(:account_number) { AccountNumber.new(' _  _  _  _  _  _  _  _  _ | || || || || || || || || ||_||_||_||_||_||_||_||_||_|                           ') }

	it "should have a string that represents the full number of 108 chars" do

		expect( account_number.account_number_string ).to be_kind_of (String)

		expect( account_number.account_number_string.length).to be == 108

	end

	xit "should have an array of digit objects" do

	end

	xit "should have 9 digits" do

	end
	
end