class Project < ApplicationRecord
  belongs_to :organization
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
end
