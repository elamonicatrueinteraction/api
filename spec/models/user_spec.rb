require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:1 relationship with the Profile model
  it { should have_one(:profile) }

  # Validation tests
  # ensure columns title and created_by are present before saving
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }

  it { should have_secure_password }
end
