require "swagger_helper"

RSpec.describe "API V1 Auth", type: :request do
  path "/api/v1/auth/login" do
    post "login" do
      tags "Auth"
      consumes "application/json"
      produces "application/json"

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response "200", "token issued" do
        let(:user) do
          User.create!(
            name: "Alice",
            email: "alice@example.com",
            password: "password12345",
            password_confirmation: "password12345"
          )
        end

        let(:credentials) { { email: user.email, password: "password12345" } }

        run_test!
      end

      response "401", "invalid credentials" do
        let(:user) do
          User.create!(
            name: "Bob",
            email: "bob@example.com",
            password: "password12345",
            password_confirmation: "password12345"
          )
        end

        let(:credentials) { { email: user.email, password: "wrongpassword123" } }

        run_test!
      end
    end
  end
end
