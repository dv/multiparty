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
@multiparty[:avatar] = {:filename => "avatar.jpg", :content => "...jpegdata..."}

# Retrieve the header and body like this:
@multiparty.header
# Content-Type: multipart/form-data; boundary=multiparty-boundary-1342
@multiparty.body
# --multiparty-boundary-1342
# Content-Disposition: form-data; name="name"
#
# David Verhasselt
# --multiparty-boundary-1342
# Content-Disposition: form-data; name="state"
# 
# awesome
# --multiparty-boundary-1342
# Content-Disposition: form-data; name="avatar"; filename="avatar.jpg"
#
# ...jpegdata...
# --multiparty-boundary-1342--
```

Installation
------------

    $ gem install multiparty

Testing
-------

    $ bundle install
    $ rake spec

Todo
----

* Nested multiparts ("multipart/mixed") not yet supported

Author
------

[David Verhasselt](http://davidverhasselt.com) - david@crowdway.com
