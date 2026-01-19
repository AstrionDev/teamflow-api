require "swagger_helper"

RSpec.describe "API V1 Organizations", type: :request do
  path "/api/v1/organizations" do
    get "list organizations" do
      tags "Organizations"
      produces "application/json"
      security [ bearerAuth: [] ]

      response "200", "success" do
        let(:user) do
          User.create!(
            name: "Owner",
            email: "owner@example.com",
            password: "password12345",
            password_confirmation: "password12345"
          )
        end

        let(:organization) { Organization.create!(name: "Acme") }

        let(:Authorization) do
          token = JsonWebToken.encode({ "sub" => user.id })
          "Bearer #{token}"
        end

        before do
          Membership.create!(user: user, organization: organization, role: "owner")
        end

        run_test!
      end

      response "401", "unauthorized" do
        run_test!
      end
    end
  end
end
