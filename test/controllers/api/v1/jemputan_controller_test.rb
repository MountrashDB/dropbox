require "test_helper"

class Api::V1::JemputanControllerTest < ActionDispatch::IntegrationTest
  test "should get alamat_jemput" do
    get api_v1_jemputan_alamat_jemput_url
    assert_response :success
  end
end
