require 'test_helper'

class Cypress::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Cypress
  end
end
