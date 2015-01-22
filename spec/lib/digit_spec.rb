require "spec_helper"
require "digit"

describe Digit do

	let(:digit) { Digit.new }

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

	xit "should convert any strings for any digit into integers" do

	end

end