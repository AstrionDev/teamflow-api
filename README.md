# Teamflow API

## Overview
This is a Rails API backend demo for a SaaS productivity platform where users manage multiple organizations, projects, and tasks. It aims to showcase clean Rails design with multi-tenant concerns, role-based access control, subscription logic, and task workflows.

## Local Setup
- `bundle install` installs Ruby dependencies.
- `bin/setup` prepares the database and clears logs/temp files.
- `bin/dev` (or `bin/rails server`) starts the server at `http://localhost:3000`.
- `bin/rails test` runs the test suite.
- `bin/rubocop` runs linting.

## Key Features

### Multi-Organization Membership
- Users can belong to multiple organizations with a role (Owner/Admin/Member).
- Role-based access control scopes authorization per organization.
- Invitations support both existing and new users.

### Organization & Subscription Management
- Organizations have subscription plans (mocked billing) with user limits.
- Owners/Admins manage team memberships and plan upgrades.
- Audit logs track organization and membership changes.

### Projects & Tasks
- Organizations contain projects; projects contain tasks.
- Tasks track status, due date, assignee, and priority.
- CRUD workflows include filtering, sorting, and pagination.
- State machine: `todo` -> `in_progress` -> `done`.
- Task access is restricted to organization members.

### Notifications & Background Jobs
- Automated reminders and notifications via Sidekiq/ActiveJob.
- Background jobs handle async workflows like emails and subscription actions.

### API-First Design
- Versioned API endpoints under `/api/v1/...`.
- JSON request/response contracts.
- JWT-based authentication and role-aware authorization per organization.

## Technical Highlights
- Rails 8.1, SQLite
- JWT authentication for secure sessions
- Pundit policies for role-aware access control
- Service objects for core business logic
- Background jobs with Sidekiq
- Multi-tenant design for realistic SaaS scenarios
- Pagination, filtering, and sorting on list endpoints
- Minitest coverage for models, services, and request specs

## Problem-Solving Showcased
- Multi-organization membership and dynamic role handling
- Secure, maintainable API endpoint design
- Task workflows and permission modeling
- Background job orchestration for production readiness
- Efficient multi-tenant database planning

## Why This Project Stands Out
- Mirrors real-world client needs for Rails backend developers
- Demonstrates complex business logic and SaaS requirements
- Easy to extend with a React/Next.js or mobile frontend
- Emphasizes clean structure, scalability, and modern Rails practices
