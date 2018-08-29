require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:1 relationship with the Profile model
  it { is_expected.to have_one(:profile) }
  it { is_expected.to belong_to(:institution) }

  # Validation tests
  # ensure columns title and created_by are present before saving
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password_digest) }

  it { is_expected.to have_secure_password }
end
