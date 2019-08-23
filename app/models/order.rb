class Order < ApplicationRecord
	belongs_to :customer
	has_many :order_products
	has_many :products, through: :order_products

	validates :status, inclusion: { in: %w[pending shipped] }

	def shippable?
		status != 'shipped' && products.count >= 1
	end

	def ship
		shippable? && update(status: 'shipped')
	end
end
