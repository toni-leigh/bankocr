require "spec_helper"
require "account_number"

describe AccountNumber do

	let(:account_number) { AccountNumber.new(' _  _  _  _  _  _  _  _  _ | || || || || || || || || ||_||_||_||_||_||_||_||_||_|                           ') }

	it "should have a string that represents the full number of 108 chars" do

		expect( account_number.account_number_string ).to be_kind_of (String)

		expect( account_number.account_number_string.length).to be == 108

	end

	it "should have an array of 9 digit objects" do

		expect( account_number.digits ).to be_kind_of (Array)

		expect( account_number.digits.length ).to be == 9

		(0..8).to_a.each do |index|
			expect(account_number.digits[index]).to be_kind_of (Digit)
		end

	end
	
end