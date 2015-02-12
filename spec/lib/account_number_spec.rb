require "spec_helper"
require "account_number"

describe AccountNumber do

	let(:number) 																{ AccountNumber.new(' _  _  _  _  _  _  _  _    ' +
																					 												'| || || || || || || ||_   |' +
																					 												'|_||_||_||_||_||_||_| _|  |' +
																					 												'                           ') }
	let(:checksum_invalid_number) 							{ AccountNumber.new(' _  _  _  _  _  _  _  _  _ ' +
																					 				 								'  || || || || || || || ||_|' +
																					 				 								'  ||_||_||_||_||_||_||_||_|' +
																					 				 								'                           ') }
	let(:salvagable_number) 										{ AccountNumber.new('|_  _  _  _  _  _  _  _    ' +
																					 				 								'| || || || || || || ||_   |' +
																					 				 								'|_||_||_||_||_||_||_| _|  |' +
																					 				 								'                           ') }
	let(:illegible_number) 											{ AccountNumber.new('||||_  _  _  _  _  _  _  _ ' +
																					 				 	  						'  || || || || || || || || |' +
																					 				 	  						'  ||_||_||_||_||_||_||_||_|' +
																					 				 	  						'                           ') }
	let(:ambiguous_checksum_invalid_number) 		{ AccountNumber.new(' _  _  _  _  _  _  _  _  _ ' +
																					 				 								'|_ |_ |_ |_ |_ |_ |_ |_ |_ ' +
																					 				 								' _| _| _| _| _| _| _| _| _|' +
																					 				 								'                           ') }

	it "should have a string that represents the full number of 108 chars" do
		expect( number.account_number_string ).to be_kind_of (String)
		expect( number.account_number_string.length).to be == 108
	end

	it "should have an array of 9 digit objects" do
		expect( number.digits ).to be_kind_of (Array)
		expect( number.digits.length ).to be == 9
		(0..8).to_a.each do |index|
			expect(number.digits[index]).to be_kind_of (Digit)
		end
	end

	it "should convert the initial string into 9 Digits with valid interger numbers stored" do
		(0..8).to_a.each do |index|
			expect(number.digits[index].number).to be_kind_of (Integer)
		end
	end

	it "should have a to_s method that returns a human readable version of the converted account number" do
		expect( number.to_s.length ).to be == 9
		expect( number.to_s ).to be == '000000051'
	end

	it "should checks its legibility by looking for invalid digits" do
		expect( number ).to be_legible
		expect( illegible_number ).not_to be_legible
	end

	it "should have ILL in to_s return if it is illegible" do
		expect( number.to_s ).not_to include("ILL")
		expect( illegible_number.to_s ).to include("ILL")
	end

	it "should validate itself by performing a checksum" do
		expect( number ).to be_checksum_valid
		expect( checksum_invalid_number ).not_to be_checksum_valid
	end 

	it "should have ERR in to_s return if it fails the checksum" do
		expect( number.to_s ).not_to include("ERR")
		expect( checksum_invalid_number.to_s ).to include("ERR")
	end

	it "should know if it is salvagable, i.e. if it has one and one only illegible digit and that digit only has one illegible character" do
		expect( number ).not_to be_salvagable
		expect( salvagable_number ).to be_salvagable
		expect( illegible_number ).not_to be_salvagable
	end

	it "should have an array of alternative numbers" do
		expect( number.alternate_numbers ).to be_kind_of (Array)
	end

	it "should have an alternative array of more than one number if it's an ambiguous error" do
		ambiguous_checksum_invalid_number.set_alternates
		expect( ambiguous_checksum_invalid_number.alternate_numbers.length ).to be > 1
	end

	it "should have exactly one alternative if it is an ILL that is actually salvagable" do
		expect( salvagable_number.alternate_numbers.length ).to be == 1 
	end

	it "should check it's ambiguity" do
		expect( number ).not_to be_ambiguous
		expect( illegible_number ).not_to be_ambiguous
		expect( ambiguous_checksum_invalid_number ).to be_ambiguous
	end

	it "should have AMB in to_s return if it is ambiguous" do
		expect( number.to_s ).not_to include("AMB")
		expect( ambiguous_checksum_invalid_number.to_s ).to include("AMB")
	end
	
end