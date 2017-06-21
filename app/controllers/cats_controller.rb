class CatsController < ApplicationController

  def new
    @cat = Cat.new
    render :new
  end

  def index
    @cats = Cat.all
    render :index
  end

  def edit
    @cat = Cat.find_by(id: params[:id])
    render :edit
  end

  def update
    @cat = Cat.find_by(id: params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      render json: @cat.errors.full_messages, status: 400
    end
  end

  def show
    @cat = Cat.find_by(id: params[:id])
    @requests = CatRentalRequest.ordered_dates(@cat.id)
    render :show
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render json: @cat.errors.full_messages, status: 400
    end
  end

  def destroy
    @cat = Cat.find_by(id: params[:id])
    if @cat.destroy
      redirect_to cats_url
    else
      render json: ['Cat does not exist D:'], status: 404
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:name, :birth_date, :sex, :color, :description)
  end
end
