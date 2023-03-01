require "test_helper"

class KycControllerTest < ActionDispatch::IntegrationTest
  test "should get province" do
    get kyc_province_url
    assert_response :success
  end

  test "should get city" do
    get kyc_city_url
    assert_response :success
  end

  test "should get district" do
    get kyc_district_url
    assert_response :success
  end
end
