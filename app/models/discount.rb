class Discount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :name,
                        :percentage,
                        :min_purchase
  validates_inclusion_of :active?, :in => [true, false]
end
