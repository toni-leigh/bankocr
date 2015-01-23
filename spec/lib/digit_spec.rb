require "spec_helper"
require "digit"

describe Digit do

	let(:digit) { Digit.new(' _ | ||_|') }

	let(:valid_digit) { Digit.new(' _ | ||_|') }  

	let(:salvagable_digit) { Digit.new('|_ | ||_|') }  

	let(:invalid_digit) { Digit.new('|||||||_|') }

	it "should have an integer value" do

		expect( digit.number ).to be_kind_of (Integer)

	end

	it "should be in the range of 0 and 9" do
		
		expect( digit.number ).to be_between(0,9)

	end

	it "should have a string representation" do

		expect( digit.string ).to be_kind_of (String)

	end

	it "should have a string length of 9" do

		expect( digit.string.length ).to be == 9

	end

	it "should convert any strings for any digit into integers" do

		Digit::VALID_STRING_REPRESENTATIONS.each do |key,value|
			digit = Digit.new(key)
			expect( digit.convert_to_integer ).to be == value
		end

	end

	it "should know whether or not it's string represents a valid integer" do

		expect( valid_digit ).to be_valid

		expect( invalid_digit ).not_to be_valid

	end

	it "should output itself as a char, including a '?' if it is invalid" do

		expect( digit.to_s ).to be_kind_of (String)

		expect( valid_digit.to_s ).to be == '0'

		expect( invalid_digit.to_s ).to be =='?'

	end

	it "should return possible alternatives if it can be ambiguous" do

		expect( digit.get_alternates(0) ).to be kind_of (Array)

		expect( digit.get_alternates(5).length ).to be == 2

		expect( digit.get_alternates(9).length ).to be == 3

	end

	it "should know if it's salvagable or not, i.e. if there's just one char difference between itself and a valid string" do

		expect( salvagable_digit ).to be_salvagable

		expect( invalid_digit ).not_to be_salvagable

	end

	it "should return a valid number if it is salvagable" do

		expect( salvagable_digit.salvage ).to be kind_of(Integer)

		expect( invalid_digit.salvage ).to be == nil

	end

end