require 'test_helper'

class Scripts::VersionsHelperTest < ActionView::TestCase
  test 'version user for' do
    version = versions :cd_root_creation

    assert_kind_of User, version_user_for(version)
  end

  test 'version change for' do
    version = versions :cd_root_creation

    assert_kind_of String, version_change_for(version)
  end

  test 'version change date for' do
    version = versions :cd_root_creation

    assert_kind_of Time, version_change_date_for(version)
  end

  test 'version diff to previous' do
    @virtual_path = ''
    @version = versions :cd_root_creation

    assert_kind_of String, version_diff_to_previous
  end
end
