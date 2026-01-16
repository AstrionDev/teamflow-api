require "test_helper"

class Api::V1::AuthorizationTest < ActionDispatch::IntegrationTest
  setup do
    @owner = User.create!(
      name: "Owner",
      email: "owner@example.com",
      password: "password12345",
      password_confirmation: "password12345"
    )
    @member = User.create!(
      name: "Member",
      email: "member@example.com",
      password: "password12345",
      password_confirmation: "password12345"
    )
    @outsider = User.create!(
      name: "Outsider",
      email: "outsider@example.com",
      password: "password12345",
      password_confirmation: "password12345"
    )

    @organization = Organization.create!(name: "Acme")
    Membership.create!(user: @owner, organization: @organization, role: "owner")
    Membership.create!(user: @member, organization: @organization, role: "member")

    @project = @organization.projects.create!(name: "Launch")
    @task = @project.tasks.create!(title: "Kickoff")
  end

  def auth_headers(user)
    token = JsonWebToken.encode({ "sub" => user.id })
    { "Authorization" => "Bearer #{token}" }
  end

  test "organization index is scoped to memberships" do
    other_org = Organization.create!(name: "Other")
    Membership.create!(user: @owner, organization: other_org, role: "member")

    get "/api/v1/organizations", headers: auth_headers(@member)

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [@organization.id], body.map { |org| org["id"] }
  end

  test "member cannot update organization" do
    patch "/api/v1/organizations/#{@organization.id}",
          params: { organization: { name: "Updated" } },
          headers: auth_headers(@member)

    assert_response :forbidden
  end

  test "owner can update organization" do
    patch "/api/v1/organizations/#{@organization.id}",
          params: { organization: { name: "Updated" } },
          headers: auth_headers(@owner)

    assert_response :success
  end

  test "member cannot add memberships" do
    post "/api/v1/organizations/#{@organization.id}/memberships",
         params: { membership: { user_id: @outsider.id, role: "member" } },
         headers: auth_headers(@member)

    assert_response :forbidden
  end

  test "owner can add memberships" do
    post "/api/v1/organizations/#{@organization.id}/memberships",
         params: { membership: { user_id: @outsider.id, role: "member" } },
         headers: auth_headers(@owner)

    assert_response :created
  end

  test "outsider cannot view project" do
    get "/api/v1/organizations/#{@organization.id}/projects/#{@project.id}",
        headers: auth_headers(@outsider)

    assert_response :forbidden
  end

  test "member can update task" do
    patch "/api/v1/organizations/#{@organization.id}/projects/#{@project.id}/tasks/#{@task.id}",
          params: { task: { title: "Updated" } },
          headers: auth_headers(@member)

    assert_response :success
  end

  test "member cannot delete task" do
    delete "/api/v1/organizations/#{@organization.id}/projects/#{@project.id}/tasks/#{@task.id}",
           headers: auth_headers(@member)

    assert_response :forbidden
  end

  test "member cannot create project" do
    post "/api/v1/organizations/#{@organization.id}/projects",
         params: { project: { name: "New Project" } },
         headers: auth_headers(@member)

    assert_response :forbidden
  end
end
