require "test_helper"

class ChatbotControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chatbot_index_url
    assert_response :success
  end

  test "should get create" do
    get chatbot_create_url
    assert_response :success
  end

  test "should get show" do
    get chatbot_show_url
    assert_response :success
  end
end
