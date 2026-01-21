require "test_helper"

class Api::V1::TasksIndexTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      name: "Member",
      email: "member@example.com",
      password: "password12345",
      password_confirmation: "password12345"
    )
    @organization = Organization.create!(name: "Acme")
    Membership.create!(user: @user, organization: @organization, role: "member")
    @project = @organization.projects.create!(name: "Launch")

    @task1 = @project.tasks.create!(
      title: "Alpha kickoff",
      status: "todo",
      priority: 0,
      due_date: Date.today + 2,
      assignee: @user,
      created_at: 3.days.ago,
      updated_at: 3.days.ago
    )
    @task2 = @project.tasks.create!(
      title: "Beta execution",
      status: "in_progress",
      priority: 2,
      due_date: Date.today,
      created_at: 2.days.ago,
      updated_at: 2.days.ago
    )
    @task3 = @project.tasks.create!(
      title: "Gamma wrap",
      status: "done",
      priority: 1,
      due_date: Date.today + 5,
      created_at: 1.day.ago,
      updated_at: 1.day.ago
    )
  end

  def auth_headers(user)
    token = JsonWebToken.encode({ "sub" => user.id })
    { "Authorization" => "Bearer #{token}" }
  end

  test "filters tasks by attributes and search" do
    get "/api/v1/organizations/#{@organization.id}/projects/#{@project.id}/tasks",
        params: {
          status: "todo",
          assignee_id: @user.id,
          priority: 0,
          due_before: (Date.today + 3).iso8601,
          search: "alpha"
        },
        headers: auth_headers(@user)

    assert_response :success
    body = JSON.parse(response.body)
    assert_equal [ @task1.id ], body.map { |task| task["id"] }
  end

  test "sorts and paginates tasks" do
    get "/api/v1/organizations/#{@organization.id}/projects/#{@project.id}/tasks",
        params: {
          sort: "due_date",
          page: 2,
          per_page: 1
        },
        headers: auth_headers(@user)

    assert_response :success
    body = JSON.parse(response.body)

    assert_equal 1, body.length
    assert_equal @task1.id, body.first["id"]
    assert_equal "3", response.headers["X-Total-Count"]
    assert_equal "3", response.headers["X-Total-Pages"]
    assert_equal "2", response.headers["X-Page"]
    assert_equal "1", response.headers["X-Per-Page"]
  end
end
