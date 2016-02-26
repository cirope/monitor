require 'test_helper'

class DatabasesHelperTest < ActionView::TestCase
  test 'database properties' do
    @database = databases :postgresql

    assert_equal @database.properties, properties

    @database = Database.new

    assert_equal 1, properties.size
    assert properties.all?(&:new_record?)
  end

  test 'value of' do
    skip
  end
end
