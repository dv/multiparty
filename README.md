multiparty
==========

Easily generate a multipart/form-data header and body.

Usage
-----

You can add multiple values, corresponding to multiple <input> statements:

```ruby
multiparty = Multiparty.new
multiparty[:name] = "David Verhasselt"
multiparty[:state] = "awesome"
# or in one statement:
multiparty << {:name => "David Verhasselt", :state => "awesome"}

multiparty[:avatar] = {:filename => "avatar.jpg", :content => "...jpegdata..."}

# Retrieve the header and body like this:
multiparty.header
# Content-Type: multipart/form-data; boundary=multiparty-boundary-1342
multiparty.body
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
# Content-Type: application/octet-stream
# Content-Transfer-Encoding: binary
#
# ...jpegdata...
# --multiparty-boundary-1342--
```

You can also add files:

```ruby
multiparty[:your_avatar] => File.open("foo.txt")
```

You can specify an optional content-type. If you don't, Multiparty will try and detect the correct MIME-type based on the filename.

```ruby
multiparty[:your_avatar] => {:filename => "foo.jpg", :content_type => "text/plain", :content => File.read("foo.txt")}
# -> Content-Type: text/plain
multiparty[:your_avatar] => {:filename => "foo.jpg", :content => "not really jpeg")}
# -> Content-Type: image/jpeg
multiparty[:your_avatar] => File.open("foo.jpg")
# -> Content-Type: image/jpeg
```

Files and Tempfiles are interchangable in Multiparty:

```ruby
tempfile = Tempfile.new("foo")
tempfile.write("Hello World!")
tempfile.rewind

multiparty[:message] => tempfile
# is the same as
multiparty[:message] => File.open(tempfile.path)
```

Multiparty has the ```to_s``` method aliased to ```body``` so you can use it as a ```String```:

```ruby
puts "Hello World! My multipart body: #{multiparty}"
```

If the API you're interface with only supports :key => :value headers, use ```header_value```:

```ruby
headers["Content-Type"] = multiparty.header_value
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
