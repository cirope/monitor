require 'test_helper'

class PaginationHelperTest < ActionView::TestCase
  include WillPaginate::ViewHelpers

  test 'pagination' do
    mock_users_controller

    users = User.paginate page: 1, per_page: 1

    assert_not_nil paginate(users)
  end

  private

    def mock_users_controller
      @controller = UsersController.new
      @controller.request = ActionDispatch::TestRequest.new
      @controller.request.action = 'index'

      def @controller.default_url_options
        { controller: 'users' }
      end
    end
end
