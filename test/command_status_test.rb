require 'minitest_helper'

describe CommandStatus do

  it "is invalid w/o a key" do
    refute CommandStatus.new.valid?
  end

  it "is valid with a key" do
    assert CommandStatus.new(key: 'key').valid?
  end

  it "should have class methods" do
    assert_respond_to CommandStatus, :ordered
    assert_respond_to CommandStatus, :keys
    assert_respond_to CommandStatus, :last_status
  end

end


