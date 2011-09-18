# http://www.w3.org/TR/html4/interact/forms.html#h-17.13
# without files:
# application/x-www-form-urlencoded  
# with files:
# multipart/form-data  

class Multiparty
  attr_accessor :boundary
  attr_accessor :parts

  # Multiparty.new("my-boundary")
  # Multiparty.new(:boundary => "my-boundary")
  def initialize(options = {})
    case options
    when Hash
      @boundary = options[:boundary]
      @content_type = options[:content_type]
    when String 
      @boundary = options
    end
   
    @parts = {}
    @content_type ||= "multipart/form-data"
    @boundary ||= "multiparty-boundary-#{rand(1000000000)}"

    yield self if block_given?
  end

  def header
    "Content-Type: #{@content_type}; boundary=#{@boundary}\r\n"
  end

  def body
    result = "--#{@boundary}\r\n"
    result << parts.map do |name, value|
      parse_part(name, value)
    end.join("\r\n")

    result << "--"
  end

  def parse_part(name, value)
    content_disposition = "form-data"
    if value.kind_of? Hash
      content_disposition = value[:content_disposition] if value[:content_disposition]
      content_type = value[:content_type]
      filename = value[:filename]
      encoding = value[:encoding]
      body_part = value[:content]
    else
      body_part = value
    end

    head_part = "Content-Disposition: #{content_disposition}; name=\"#{name}\""
    head_part << "; filename=\"#{filename}\"" if filename
    head_part << "\r\n"
    head_part << "Content-Type: #{content_type}\r\n" if content_type
    head_part << "Content-Transfer-Encoding: #{encoding}\r\n" if encoding

    "#{head_part}\r\n#{body_part}\r\n--#{@boundary}"
  end

  # Actionable methods
  # If value is a hash, it's a file
  #  add_part("avatar", {:filename => "avatar.jpg", :content => "..."})
  # If value is a string
  #   take it from facevalue
  # If value is an array, it is 
  #   
  def add_part(index, value)
    parts[index] = value
  end
  alias_method :[]=, :add_part

end
