require "test_helper"

class Api::V1::Outlet::OutletControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get api_v1_outlet_outlet_login_url
    assert_response :success
  end
end
