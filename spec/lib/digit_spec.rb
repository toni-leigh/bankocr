require "spec_helper"
require "digit"

describe Digit do

	let(:digit) { Digit.new(' _ | ||_|') }

	let(:valid_digit) { Digit.new(' _ | ||_|') }  

	let(:salvagable_digit) { Digit.new('|_ | ||_|') }  

	let(:illegible_digit) { Digit.new('|||||||_|') }

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

		Digit::DIGIT_DATA.each do |integer,data|
			digit = Digit.new(data['string'])
			expect( digit.number ).to be == integer
		end

	end

	it "should know whether or not it's string represents a valid integer" do

		expect( valid_digit ).to be_valid

		expect( illegible_digit ).not_to be_valid

	end

	it "should output itself as a char, including a '?' if it is invalid" do

		expect( digit.to_s ).to be_kind_of (String)

		expect( valid_digit.to_s ).to be == '0'

		expect( illegible_digit.to_s ).to be =='?'

	end

	it "should return possible alternatives if it can be ambiguous" do

		expect( digit.set_from_integer(0).get_alternates ).to be_kind_of (Array)

		expect( digit.set_from_integer(5).get_alternates.length ).to be == 2

		expect( digit.set_from_integer(9).get_alternates.length ).to be == 3

		expect( digit.set_from_integer(4).get_alternates.length ).to be == 0

	end

	it "should know if it's salvagable or not, i.e. if there's just one char difference between itself and a valid string" do

		expect( salvagable_digit ).to be_salvagable

		expect( illegible_digit ).not_to be_salvagable

	end

	it "should return a valid number if it is salvagable" do

		expect( salvagable_digit.salvage ).to be_kind_of(Integer)

		expect( salvagable_digit.salvage ).to be == 0

		expect( illegible_digit.salvage ).to be == nil

	end

end