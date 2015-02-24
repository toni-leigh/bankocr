require "spec_helper"
require "digit"

describe Digit do

  let(:valid_digit) {
    Digit.new(' _ ' +
              '| |' +
              '|_|')
  }
  let(:salvagable_digit) {
    Digit.new('|_ ' +
              '| |' +
              '|_|')
  }
  let(:illegible_digit) {
    Digit.new('|||' +
              '|||' +
              '|_|')
  }

  it "should have an integer value" do
    expect( valid_digit.integer ).to be_kind_of (Integer)
  end

  it "should be in the range of 0 and 9" do
    expect( valid_digit.integer ).to be_between(0,9)
  end

  it "should have a string representation" do
    expect( valid_digit.string ).to be_kind_of (String)
  end

  it "should have a string length of 9" do
    expect( valid_digit.string.length ).to be == 9
  end

  it "should convert any strings for any digit into integers" do
    Digit::DIGIT_DATA.each do |integer,data|
      d = Digit.new(data['string'])
      expect( d.integer ).to be == integer
    end
  end

  it "should know whether or not it's string represents a valid integer" do
    expect( valid_digit.valid ).to eq(true)
    expect( illegible_digit.valid ).not_to eq(true)
  end

  it "should output itself as a char, including a '?' if it is invalid" do
    expect( valid_digit.to_s ).to be_kind_of (String)
    expect( valid_digit.to_s ).to be == '0'
    expect( illegible_digit.to_s ).to be =='?'
  end

  it "should know what it's alternatives are if it's valid" do
    expect( valid_digit.get_alternates ).to be_kind_of (Array)

    Digit::DIGIT_DATA.each do |integer,data|
      d = Digit.new(data['string'])
      expect( d.get_alternates ).to be_kind_of (Array)
      expect( d.get_alternates.length ).to be == data['ambiguities'].length
    end
  end

  it "should know if it's salvagable or not, i.e. if there's just one char difference between itself and a valid string" do
    expect( salvagable_digit.salvagable ).to eq(true)
    expect( illegible_digit.salvagable ).not_to eq(true)
  end

  it "should return a valid number if it is salvagable" do
    expect( salvagable_digit.salvage_to ).to be_kind_of(Integer)
    expect( salvagable_digit.salvage_to ).to be == 0
    expect( illegible_digit.salvage_to ).to be == nil
  end

end
