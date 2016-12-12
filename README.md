z85rb - pure Ruby implementation of Z85 encoding
================================================

## Installation

Add this line to your application's Gemfile:

    gem 'z85rb'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install z85rb

## Usage

```rb
encode("\x86\x4f\xd2\x6f\xb5\x59\xf7\x5b") # => 'HelloWorld'
decode('nm=QNzY&b1A+]nf') # => 'Hello World!'
```

Encoding data not padded to a multiple of 4 will raise `ArgumentError`.

## Difference to reference implementation in C:

When input binary form in encoding is not bounded to 4 bytes, or input string
frame in decoding is not bounded to 5 bytes, the [reference implementation][c]
returns `NULL`.

Instead of returning `nil`, we raise an `ArgumentError`.

Raising an exception conforms the [specification][rfc]. We guess that the reference
implementation returns `NULL` is because C does not have native support for
exceptions.

## Difference to z85 C extension for ruby

This gem is a drop-in replace for [z85 C extension][z85].
API is the same.

There is only one difference:

When input is invalid (not bounded to 4 or 5 bytes),  this gem raises an
`ArgumentError` while z85 C extension raises `RuntimeError`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## References

- [Z85 - ZeroMQ Base-85 Encoding Algorithm][rfc]
- [A reference implementation in C][c]

[rfc]: http://rfc.zeromq.org/spec:32
[c]: https://github.com/zeromq/rfc/blob/master/src/spec_32.c
[z85]: https://github.com/fpesce/z85/

## License

0BSD
