require "test_helper"

class TaskTest < ActiveSupport::TestCase
  setup do
    @organization = Organization.create!(name: "Acme")
    @project = @organization.projects.create!(name: "Launch")
  end

  test "allows forward status transitions" do
    task = @project.tasks.create!(title: "Kickoff")

    task.update!(status: "in_progress")
    task.update!(status: "done")

    assert_equal "done", task.status
  end

  test "blocks invalid status transitions" do
    task = @project.tasks.create!(title: "Kickoff")

    task.status = "done"

    assert_not task.valid?
    assert_includes task.errors[:status], "cannot transition from todo to done"
  end

  test "blocks backward transitions from in_progress" do
    task = @project.tasks.create!(title: "Kickoff", status: "in_progress")

    task.status = "todo"

    assert_not task.valid?
  end
end
