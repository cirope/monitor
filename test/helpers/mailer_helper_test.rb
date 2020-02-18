# frozen_string_literal: true

require 'test_helper'

class MailerHelperTest < ActionView::TestCase
  test 'render object for email' do
    assert_match '<table>', render_object_for_email(one: 1)
    assert_match '<ul>', render_object_for_email(['one', 'two'])
  end

  test 'link to next reference' do
    assert_match /href="#ref-\d+"/, link_to_next_reference
  end
end
