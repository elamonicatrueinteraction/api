require 'rails_helper'

RSpec.describe InstitutionServices, type: :model do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:frequency) }
  it { is_expected.to respond_to(:benefiaries_quantity) }
  
  it { is_expected.to respond_to(:type_name) }
  it { expect(subject.class).to respond_to(:valid_types) }
  it { expect(subject.class.valid_types).to contain_exactly('copa de leche', 'almuerzo', 'desayuno', 'merienda', 'cena') }
end
