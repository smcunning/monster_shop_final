class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
  end

  def show
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:alert] = 'New discount created successfully!'
      redirect_to "/merchant/discounts"
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @merchant = current_user.merchant
    @discount = Discount.find(params[:id])
  end

  private
  def discount_params
    params.permit(:name,:percentage,:min_purchase)
  end
end
