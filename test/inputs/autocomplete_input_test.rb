# frozen_string_literal: true

require 'test_helper'

class AutocompleteInputTest < ActionView::TestCase
  test 'input' do
    simple_fields_for(Job.new) do |f|
      input = f.input :server, as: :autocomplete, url: servers_path

      assert_match /data-autocomplete-url/, input
    end
  end
end
