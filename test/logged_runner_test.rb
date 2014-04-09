require 'minitest_helper'

describe LoggedRunner do

  it "exception w/o block" do
    assert_raises LoggedRunner::LoggedRunnerBlockRequiredException do
      lr = LoggedRunner.run('test_key', :import)
    end
  end

  it "basic" do
    lr = LoggedRunner.new('test_key', :import) { Dummy}
    assert_equal 'test_key', lr.key
    assert_equal :import, lr.method
    assert_nil lr.args
  end

  it "basic with args" do
    lr = LoggedRunner.new('test_key', :import, ['Arg1', 23]) { Dummy }
    assert_equal 'test_key', lr.key
    assert_equal :import, lr.method
    assert_equal ["Arg1", 23], lr.args
  end

  describe "ar:rel" do

    def setup
      Dummy.create(kind: 2, name: 'junk')
      Dummy.create(kind: 1, name: 'first')
      Dummy.create(kind: 1, name: 'second')
    end

    def teardown
      clean_database!
    end

    it "should be successful" do
      lr = LoggedRunner.run('string_size', :name) { Dummy.filtered }
      assert_equal 2, lr.cs.total_count
      assert_equal 2, lr.cs.success_count
      assert_equal 'OK', lr.cs.status
    end

    it "should fail" do
      lr = LoggedRunner.run('string_size', :name_zzzz) { Dummy.filtered }
      assert_equal 2, lr.cs.total_count
      assert_equal 0, lr.cs.success_count
      assert_equal 'FAIL', lr.cs.status
    end
  end

  it "success for an array" do
    lr = LoggedRunner.run('string_size', :size) { ['one', 'seven', 'nine'] }
    assert_equal 3, lr.cs.total_count
    assert_equal 3, lr.cs.success_count
    assert_equal 'OK', lr.cs.status
  end

  it "partial success for an array" do
    lr = LoggedRunner.run('string_size', :size) { ['one', String, 'nine'] }
    assert_equal 3, lr.cs.total_count
    assert_equal 2, lr.cs.success_count
    assert_equal 'PARTIAL', lr.cs.status
    assert_equal 'String', lr.cs.failed_instance
  end

  it "success for an object" do
    lr = LoggedRunner.run('string_size', :size) { 'one' }
    assert_equal 1, lr.cs.total_count
    assert_equal 1, lr.cs.success_count
    assert_equal 'OK', lr.cs.status
  end

  it "failure for an object" do
    lr = LoggedRunner.run('string_size', :size_zzzzz) { 'one' }
    assert_equal 1, lr.cs.total_count
    assert_equal 1, lr.cs.success_count
    assert_equal 'OK', lr.cs.status
  end

  it "success for a class" do
    lr = LoggedRunner.run('device_count', :count) { Dummy }
    assert_equal 1, lr.cs.total_count
    assert_equal 1, lr.cs.success_count
    assert_equal 'OK', lr.cs.status
  end

  it "failure for a class" do
    lr = LoggedRunner.run('device_count', :count_zzzzz) { Dummy }
    assert_equal 1, lr.cs.total_count
    assert_equal 1, lr.cs.success_count
    assert_equal 'OK', lr.cs.status
  end

end
