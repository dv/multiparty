require "mime/types"
require "tempfile"

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
    "Content-Type: #{header_value}\r\n"
  end

  def header_value
    "#{@content_type}; boundary=#{@boundary}"  
  end

  def body
    result = "--#{@boundary}\r\n"
    result << parts.map do |name, value|
      parse_part(name, value)
    end.join("\r\n")

    result << "--"
  end
  alias_method :to_s, :body

  def parse_part(name, value)
    content_disposition = "form-data"
    case value
    when Hash
      content_disposition = value[:content_disposition] if value[:content_disposition]
      content_type = value[:content_type]
      filename = value[:filename]
      encoding = value[:encoding]
      body_part = value[:content]
    when File, Tempfile
      content_type = "application/octet-stream"
      filename = File.split(value.path).last
      body_part = value.read
    when Array
      return value.map { |v| parse_part("#{name}[]", v) }.join "\r\n"
    else
      body_part = value
    end
    
    if filename
      content_type ||= MIME::Types.of(filename).first.to_s || "application/octet-stream"
      encoding ||= "binary"
    end

    head_part = "Content-Disposition: #{content_disposition}; name=\"#{name}\""
    head_part << "; filename=\"#{filename}\"" if filename
    head_part << "\r\n"
    head_part << "Content-Type: #{content_type}\r\n" if content_type
    head_part << "Content-Transfer-Encoding: #{encoding}\r\n" if encoding

    "#{head_part}\r\n#{body_part}\r\n--#{@boundary}"
  end

  def get_part(index)
    parts[index]
  end
  alias_method :[], :get_part

  def add_part(index, value)
    parts[index] = value
  end
  alias_method :[]=, :add_part

  def add_parts(parts)
    parts.each do |index, value|
      add_part(index, value)
    end
  end
  alias_method :<<, :add_parts

end
