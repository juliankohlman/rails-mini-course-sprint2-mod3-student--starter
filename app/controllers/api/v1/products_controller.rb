module Api
	module V1
		class ProductsController < ApplicationController
			def index
				if params[:order_id].present?
					@products = Order.find(params[:order_id]).products
				else
					# @products = Product.where('inventory > ?', 0).order(:cost)
					@products = Product.in_stock
				end
				render json: @products
			end

			def show
				@product = Product.find(params[:id])

				render json: @product
			end

			def create
				@order = Order.find(params[:order_id])
				@order_product = @order.order_products.build(order_product_params)

				if @order_product.save
					render json: @order,
					       status: :created,
					       location: api_v1_order_url(@order)
				else
					render json: { message: 'Unable to add product to order' },
					       status: :unprocessable_entity
				end
			end

			private

			def order_product_params
				params.require(:product).permit(:product_id)
			end
		end
	end
end
