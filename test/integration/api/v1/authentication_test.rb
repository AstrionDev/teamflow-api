require "test_helper"

class Api::V1::AuthenticationTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Alice",
      email: "alice@example.com",
      password: "password12345",
      password_confirmation: "password12345"
    )
  end

  test "login returns token with valid credentials" do
    post "/api/v1/auth/login", params: { email: @user.email, password: "password12345" }

    assert_response :success
    body = JSON.parse(response.body)
    assert body["token"].present?
  end

  test "login rejects invalid credentials" do
    post "/api/v1/auth/login", params: { email: @user.email, password: "wrongpassword123" }

    assert_response :unauthorized
  end

  test "protected endpoints require a token" do
    get "/api/v1/organizations"

    assert_response :unauthorized
  end
end
