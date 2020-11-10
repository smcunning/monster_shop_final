class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(current_user.merchant_id)
  end

  def new
    @merchant = current_user.merchant
    @discount = Discount.new
  end

  def show
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:alert] = 'New discount created successfully!'
      redirect_to merchant_discounts_path
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      redirect_to new_merchant_discount_path
    end
  end

  def edit
    @merchant = current_user.merchant
    @discount = Discount.find(params[:id])
  end

  def update
    if params[:status]
      toggle_activation
    else
      @discount = Discount.find(params[:format])
      @discount.attributes = discount_params
      if @discount.save
        flash[:success] = 'Discount has been successfully updated!'
        redirect_to merchant_discounts_path
      else
        flash[:error] = @discount.errors.full_messages.to_sentence
        redirect_to "/merchant/discounts/#{@discount.id}/edit"
      end
    end
  end

  def destroy
    Discount.find(params[:id]).destroy
    redirect_to merchant_discounts_path
  end

  def toggle_activation
    @discount = Discount.find(params[:id])
    if params[:status] == 'deactivate'
      @discount.update(:active? => false)
      flash[:alert] = 'This discount is now inactive.'
    elsif params[:status] == 'activate'
      @discount.update(:active? => true)
      flash[:alert] = 'This discount is now activated.'
    end
    redirect_to "/merchant/discounts"
  end

  private
  def discount_params
    params.require(:discount).permit(:name, :percentage, :min_purchase, :id)
  end
end
