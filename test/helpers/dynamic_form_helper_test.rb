require 'test_helper'

class DynamicFormHelperTest < ActionView::TestCase
  test 'link to add fields' do
    simple_fields_for(Script.new) do |f|
      link = link_to_add_fields 'Add relation', f, :requires

      assert_match /addNestedItem/, link
    end
  end

  test 'link to remove nested item' do
    simple_fields_for(Require.new) do |f|
      link = link_to_remove_nested_item f

      assert_match /removeItem/, link
    end
  end

  test 'link to hide nested item' do
    simple_fields_for(requires :cd_root_before_ls) do |f|
      link = link_to_remove_nested_item f

      assert_match /hideItem/, link
    end
  end
end
