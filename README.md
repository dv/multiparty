multiparty
==========

Easily generate a multipart/form-data header and body.

Usage
-----

You can add multiple values, corresponding to multiple <input> statements:
```ruby
@multiparty = Multiparty.new
@multiparty[:name] = "David Verhasselt"
@multiparty[:state] = "awesome"

# Retrieve the header and body like this:
@multiparty.header
@multiparty.body
```

Installation
------------

    $ gem install multiparty

Testing
-------

    $ bundle install
    $ rake spec

Author
------

[David Verhasselt](http://davidverhasselt.com) - david@crowdway.com
