require_relative 'z85rb/version'

module Z85rb
  module_function

  # Encode binary data into Z85.
  #
  # @param data [String] binary
  # @return [String] Z85 encoded
  #
  # @example HelloWorld
  #   # Encode to 'HelloWorld' is an example from Z85 RFC.
  #   encode("\x86\x4f\xd2\x6f\xb5\x59\xf7\x5b") #=> 'HelloWorld'
  #   encode('Hello World!') #=> 'nm=QNzY&b1A+]nf'
  #
  # @example Not padded to a multiple of 4
  #   assert_raise(ArgumentError) { encode('HelloWorld') } #=> true
  #
  # @example longer data
  #   # Borrowed from Z85 reference implementation in C.
  #   test_data_2 = "\x8E\v\xDDiv(\xB9\x1D\x8F$U\x87\xEE\x95\xC5\xB0MH\x96?y%\x98w\xB4\x9C\xD9\x06:\xEA\xD3\xB7"
  #   encode(test_data_2) #=> 'JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6'
  def encode(data)
    if data.length % 4 != 0
		  raise ArgumentError, 'The input binary frame should have a length that is divisible by 4 with no remainder.'
    end

    encoder = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-:+=^!/*?&<>()[]{}@%$#'
		str = ''
		byte_nbr = 0
		size = data.length
		value = 0
    while byte_nbr < size
      value = (value * 256) + data[byte_nbr].ord
      byte_nbr += 1
      if byte_nbr % 4 == 0
        divisor = 85 * 85 * 85 * 85
        while divisor >= 1
          idx = (value / divisor).floor % 85
          str += encoder[idx]
          divisor /= 85
        end
        value = 0
      end
    end
	  str
  end

  # Decode Z85 to binary string.
  #
  # @param string [String] Z85 encoded
  # @return [String] binary
  #
  # @example HelloWorld
  #   decode('HelloWorld') #=> "\x86\x4f\xd2\x6f\xb5\x59\xf7\x5b"
  #   decode('nm=QNzY&b1A+]nf') #=> 'Hello World!'
  #
  # @example Not padded to a multiple of 5
  #   assert_raise(ArgumentError) { decode('hello_world') } #=> true
  #
  # @example longer data
  #   decode('JTKVSB%%)wK0E.X)V>+}o?pNmC{O&4W4b!Ni{Lh6')
  #   #=> "\x8E\v\xDDiv(\xB9\x1D\x8F$U\x87\xEE\x95\xC5\xB0MH\x96?y%\x98w\xB4\x9C\xD9\x06:\xEA\xD3\xB7"
  def decode(string)
    if string.length % 5 != 0
       raise ArgumentError, 'The input string frame should have a length that is divisible by 5 with no remainder.'
    end

    decoder = [
    0x00, 0x44, 0x00, 0x54, 0x53, 0x52, 0x48, 0x00,
    0x4B, 0x4C, 0x46, 0x41, 0x00, 0x3F, 0x3E, 0x45,
    0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
    0x08, 0x09, 0x40, 0x00, 0x49, 0x42, 0x4A, 0x47,
    0x51, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A,
    0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32,
    0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3A,
    0x3B, 0x3C, 0x3D, 0x4D, 0x00, 0x4E, 0x43, 0x00,
    0x00, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10,
    0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
    0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20,
    0x21, 0x22, 0x23, 0x4F, 0x00, 0x50, 0x00, 0x00,
    ]
	  dest = []
		byte_nbr = 0
		char_nbr = 0
		string_len = string.length
		value = 0
    while char_nbr < string_len
      idx = string[char_nbr].ord - 32
      value = (value * 85) + decoder[idx]
      char_nbr += 1
      if char_nbr % 5 == 0
        divisor = 256 * 256 * 256
        while divisor >= 1
          dest[byte_nbr] = (value / divisor) % 256
          byte_nbr += 1
          divisor /= 256
        end
        value = 0
      end
    end
    # We think `C*` and `c*` is equivalent in this case.
    # We use `C*` merely because reference implement in C uses `unsigned char`.
    # https://github.com/zeromq/rfc/blob/master/src/spec_32.c#
    dest.pack 'C*'
  end
end
