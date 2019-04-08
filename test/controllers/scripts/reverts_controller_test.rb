# frozen_string_literal: true

require 'test_helper'

class Scripts::RevertsControllerTest < ActionController::TestCase
  setup do
    @version = versions :cd_root_creation

    login
  end

  test 'should revert script to version' do
    # default fixture version can not be restored
    item = @version.item

    item.update!(
      change: 'New commit',
      text:   'ls',
      name:   'Listing'
    )

    new_version = item.versions.last

    post :create, params: { script_id: item.id, id: new_version.id }
    assert_redirected_to script_path(item.id)
  end

  test 'should not restore script from version' do
    # default fixture version can not be restored
    post :create, params: { script_id: @version.item_id, id: @version }

    assert_redirected_to script_version_path(@version.item_id, @version.id)
  end
end
