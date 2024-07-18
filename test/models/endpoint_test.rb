# frozen_string_literal: true

require 'test_helper'

class EndpointTest < ActiveSupport::TestCase
  setup do
    @endpoint = endpoints :dynamics
  end

  test 'blank attributes' do
    @endpoint.name = ''
    @endpoint.provider = ''

    assert @endpoint.invalid?
    assert_error @endpoint, :name, :blank
    assert_error @endpoint, :provider, :blank
  end

  test 'blank dynamics options' do
    required_options = Endpoint.required_options @endpoint.provider

    required_options.each { |option| @endpoint.send("#{option}=", '') }

    assert @endpoint.invalid?

    required_options.each do |option|
      assert_error @endpoint, option, :blank
    end
  end

  test 'unique attributes' do
    endpoint = @endpoint.dup

    assert endpoint.invalid?
    assert_error endpoint, :name, :taken
  end
end
