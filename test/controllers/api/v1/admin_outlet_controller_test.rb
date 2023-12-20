require "test_helper"

class Api::V1::AdminOutletControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_admin_outlet_create_url
    assert_response :success
  end
end
