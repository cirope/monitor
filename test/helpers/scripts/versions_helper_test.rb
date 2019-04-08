# frozen_string_literal: true

require 'test_helper'

class Scripts::VersionsHelperTest < ActionView::TestCase
  test 'version change for' do
    version = versions :cd_root_creation

    assert_kind_of String, version_change_for(version)
  end

  test 'version change date for' do
    version = versions :cd_root_creation

    assert_kind_of Time, version_change_date_for(version)
  end

  test 'text diff for version' do
    @version = versions :cd_root_creation
    @version.update_column :object_changes, { 'text' => [nil, 'puts "Hola mundo"'] }

    assert_kind_of String, text_diff_for_version
  end
end
