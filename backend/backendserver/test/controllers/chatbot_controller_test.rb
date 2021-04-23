require "test_helper"

class ChatbotControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chatbot_index_url
    assert_response :success
  end

  test "should get request" do
    get chatbot_request_url
    assert_response :success
  end

  test "should get callback" do
    get chatbot_callback_url
    assert_response :success
  end
end
