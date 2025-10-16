require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    subject { create(:customer) }

    it { should validate_presence_of(:customer_name) }
    it { should validate_presence_of(:address) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:customer)).to be_valid
    end
  end
end