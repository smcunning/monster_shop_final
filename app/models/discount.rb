class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name,
                        :percentage,
                        :min_purchase
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :percentage, greater_than: 1, less_than: 100
  validates_numericality_of :min_purchase, greater_than: 0
end
