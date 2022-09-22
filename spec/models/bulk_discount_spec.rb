require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :discount }
    it { should validate_presence_of :threshold }
    it { should validate_numericality_of(:discount).is_greater_than(0).is_less_than_or_equal_to(100) }
  end

  describe 'relationships' do
    it {should belong_to :merchant }
  end
end