class AccountNumber

  attr_accessor :account_number_length,
    :account_number_string,
    :alternate_numbers,
    :ambiguous,
    :checksum_valid,
    :digits,
    :legible,
    :salvagable

  alias_method :ambiguous?, :ambiguous
  alias_method :legible?, :legible
  alias_method :salvagable?, :salvagable
  alias_method :checksum_valid?, :checksum_valid



  def initialize(account_number_string = '', account_number_length = 9)
    @account_number_length = account_number_length
    @digits = Array.new(account_number_length)
    @alternate_numbers = []
    @alternate = false
    @account_number_string = account_number_string
    @ambiguous = false
    @salvagable = false
    set_from_string if account_number_string.length > 0
  end



  # is the account number invlid but have more than one valid alternative
  # set looks at the count of alternate numbers
  def set_ambiguous
    @ambiguous = true if alternate_numbers.length > 1
  end



  # does the account number pass the checksum validation
  def set_checksum_valid
    checksum = 0;

    (0..(account_number_length - 1)).each do |i|
      integer = digits[(account_number_length - 1) - i].integer
      checksum += (integer * (i + 1)) if integer
    end

    @checksum_valid = ( checksum % 11 == 0 )
  end



  # is the account number salvagable? i.e. does it have error digit with
  # just one error in the digit itself
  # set method checks Digit.salvagbale status and also makes sure just one Digit
  # is invalid
  def set_salvagable
    salvagables = 0
    valid_digits = 0
    digits.each do |digit|
      salvagables += 1 if digit.salvagable?
      valid_digits += 1 if digit.valid?
    end
    # counting just one salvagable isn't enough, need eight valids for it to be a truly salvagable
    # acc number
    @salvagable = true if salvagables == 1 && valid_digits == (account_number_length - 1)
  end



  # is the account number legible, are all digits readable? An account
  # number can be illegible and salvagable, or illegible and not salvagable
  def set_legible
    @legible = true

    (0..(account_number_length - 1)).each do |i|
      @legible = false if digits[(account_number_length - 1)-i].integer == nil
    end
  end



  # looks at the account number string and extracts the 3x3 charset that
  # respresents the digit
  #
  # position - Integer that represents the position, 0 - (@account_number_length - 1) to target
  #
  # return - @account_number_length char string that represents the digit
  def get_digit_string(position)
    [
      account_number_string[position * 3,3],
      account_number_string[position * 3 + (account_number_length * 3),3],
      account_number_string[position * 3 + (account_number_length * 3 * 2),3]
    ].join('')
  end



  # builds an alternate integer array - used for ambiguous account numbers
  def get_alternate_integer_array(new_digit,target_index)
    integer_array = []

    digits.each do |digit|
      integer_array << digit.integer
    end

    integer_array[target_index] = new_digit

    integer_array
  end



  # sets up the Digit array based on the string input and validates
  def set_from_string
    digits.each_with_index do |digit,index|
      @digits[index] = Digit.new(get_digit_string(index))
    end

    set_checksum_valid
    set_legible

    set_salvagable unless legible?

    if legible? && !checksum_valid?
      set_alternates
      apply_alternate
    end

    if salvagable?
      salvage_number
      apply_alternate
    end
  end



  # over-writes the Digit array based on an array of Integers, which skips
  # the validations for legibility and salvagability
  def set_from_integers(integer_array)
    integer_array.each_with_index do |integer,index|
      @digits[index] = Digit.new.set_from_integer(integer);
    end
    set_checksum_valid
    set_legible
  end



  # looks through the account number and builds alternate numbers, using ambiguous
  # digits, adding them to the alternate numbers arrays
  def set_alternates
    digits.each_with_index do |digit,index|
      digit.get_alternates.to_a.each do |alternate_digit|
        alternate_integer_array = get_alternate_integer_array(alternate_digit,index)
        add_new_alternate(alternate_integer_array)
      end
    end

    set_ambiguous
  end



  # builds an integer array from a salvagble number storing it as an alternate
  def salvage_number
    alternate_integer_array = []
    digits.each do |digit|
      alternate_integer_array << (digit.valid? ? digit.integer : digit.salvage_to)
    end
    add_new_alternate(alternate_integer_array)
  end



  # creates a new AccountNumber object and adds that to the alternate numbers
  # array if it is valid
  def add_new_alternate(alternate_integer_array)
    alternate_account_number = AccountNumber.new
    alternate_account_number.set_from_integers(alternate_integer_array)

    @alternate_numbers << alternate_account_number if alternate_account_number.checksum_valid?
  end



  # if there is one alternate then apply it else do nothing
  # also an applied alternate is valid and legible
  def apply_alternate
    if alternate_numbers.length == 1
      @digits = alternate_numbers[0].digits
      @checksum_valid = true
      @legible = true
    end
  end



  # get an error code applicable
  def error_code
    return ' AMB' if ambiguous
    return ' ILL' if !legible
    return ' ERR' if !checksum_valid
  end



  # over-ridden to string method
  def to_s
    output_string = ''

    digits.each do |digit|
      output_string += "#{digit.to_s}"
    end

    output_string += error_code || ''

    alternates = []
    if alternate_numbers.length > 1
      alternate_numbers.each do |alternate|
        alternates << alternate.to_s
      end
      output_string += '[' + alternates.join(', ') + ']'
    end

    output_string
  end
end
