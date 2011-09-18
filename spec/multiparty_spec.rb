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
    end

    it "should be able to set-index a key-value pair" do
      @multiparty[:key] = :value
      @multiparty[:key] = {:filename => "hello.jpg", :content => ""}
    end

    it "should return a correctly formed multipart response" do
      @multiparty.boundary = "AaB03x"
      @multiparty['submit-name'] = "Larry"
      @multiparty['files'] = {:filename => "file1.txt", :content_type => "text/plain", :content => "... contents of file1.txt ..."}

      @multiparty.body.should == '--AaB03x
Content-Disposition: form-data; name="submit-name"

Larry
--AaB03x
Content-Disposition: form-data; name="files"; filename="file1.txt"
Content-Type: text/plain

... contents of file1.txt ...
--AaB03x--'.gsub("\n", "\r\n")
    end
  end    
end