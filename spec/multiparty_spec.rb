require File.dirname(__FILE__) + '/spec_helper'

describe "multiparty" do
  it "should initialize" do
    Multiparty.new.should_not be_nil
  end

  it "should accept a string as the boundary in #initialize" do
    multiparty = Multiparty.new("my-boundary")
    multiparty.boundary.should == "my-boundary"
  end

  it "should accept an option has in #initialize" do
    multiparty = Multiparty.new :boundary => "my-boundary"
    multiparty.boundary.should == "my-boundary"
  end

  it "should execute a block in #initialize" do
    blocktest = false
    Multiparty.new do
      blocktest = true
    end

    blocktest.should be true 
  end

  describe "instance" do
    before(:each) do
      @multiparty = Multiparty.new("my-boundary")
    end

    it "should return a correct header" do
      @multiparty.header.should == "Content-Type: multipart/form-data; boundary=my-boundary\r\n"
      @multiparty.header.should == "Content-Type: #{@multiparty.header_value}\r\n"
    end

    it "should be able to set-index a key-value pair" do
      @multiparty[:key] = :value
      @multiparty[:key] = {:filename => "hello.jpg", :content => ""}
    end

    it "should have a decent #to_s method" do
      @multiparty[:key] = :value
      @multiparty.body.should == "#{@multiparty}"
    end

    it "should be able to add multiple parts at once" do
      multiparty1 = Multiparty.new("my-boundary")
      multiparty2 = Multiparty.new("my-boundary")

      multiparty1 << {:key1 => :value1, :key2 => :value2}
      multiparty2[:key1] = :value1
      multiparty2[:key2] = :value2

      multiparty1.body.should == multiparty2.body
    end

    it "should return a correctly formed multipart response" do
      @multiparty.boundary = "AaB03x"
      @multiparty['submit-name'] = "Larry"
      @multiparty['files'] = {:filename => "file1.txt", :content_type => "text/plain", :content => "... contents of file1.txt ..."}

      @multiparty.body.gsub("\r\n", "\n").should == '--AaB03x
Content-Disposition: form-data; name="submit-name"

Larry
--AaB03x
Content-Disposition: form-data; name="files"; filename="file1.txt"
Content-Type: text/plain
Content-Transfer-Encoding: binary

... contents of file1.txt ...
--AaB03x--'
    end

    it "should accept a File" do
      begin
        @tempfile = Tempfile.new("foo.txt")
        @tempfile.write("Hi world!")
        @tempfile.rewind
        name = File.split(@tempfile.path).last

        @multiparty[:bar] = @tempfile
        @multiparty.body.gsub("\r\n", "\n").should == '--my-boundary
Content-Disposition: form-data; name="bar"; filename="' + name + '"
Content-Type: application/octet-stream
Content-Transfer-Encoding: binary

Hi world!
--my-boundary--'
      ensure
        @tempfile.close
        @tempfile.unlink
      end
    end
  end    
end
