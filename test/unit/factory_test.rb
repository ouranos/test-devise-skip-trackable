require 'test_helper'

# Test that our factories are valid

class FactoryTest < ActiveSupport::TestCase

  def assert_valid(model)
    assert(model.valid?, "#{model.class} should be valid. Error: #{model.errors.full_messages.to_sentence}")
  end

  FactoryGirl.factories.map(&:name).each do |factory_name|
    test "Factory #{factory_name} is valid" do
      assert_valid FactoryGirl.create(factory_name)
    end
  end
end