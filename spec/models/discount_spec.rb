require 'rails_helper'

describe Discount, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :percentage }
    it { should validate_presence_of :min_purchase }
    it { should allow_value(%w(true false)).for(:active?) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end
end 
