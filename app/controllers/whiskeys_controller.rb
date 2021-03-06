class WhiskeysController < ApplicationController
  before_action :set_whiskey!, except: [:create, :index, :new]




  def index
    #  byebug
    if params[:user_id]
      @whiskeys = User.find(params[:user_id]).whiskeys
      respond_to do |f|
       f.json {render json: @whiskeys}
       f.html {render :index}

      end
    else
      @whiskeys = Whiskey.all
      respond_to do |f|
        f.json {render json: @whiskeys}
        f.html {render :index}
      end
    end

  end


  def show
      respond_to do |f|
        f.json{render json: @whiskey}
      end
  end

  # def new
  #   @whiskey = Whiskey.new
  #
  # end

  def create
    @whiskey = Whiskey.create(whiskey_params)
    current_user.whiskeys << @whiskey
    render json: @whiskey, status: 201
    @distiller = @whiskey.build_distiller
    @region = @whiskey.distiller.build_region

  end

  def edit

  end

  def update

    @whiskey.update(whiskey_params)

    if @whiskey.save
      redirect_to @whiskey
    else
      render :edit
    end
  end


  def destroy
    @whiskey.destroy
    redirect_to whiskey_path
  end

  def add

      current_user.whiskeys << @whiskey
      redirect_to current_user
  end

  def remove
      current_user.whiskeys.delete(@whiskey)
      current_user.save
      redirect_to current_user
  end


  private

    def set_whiskey!
      @whiskey = Whiskey.find(params[:id])
    end

    def whiskey_params
      params.require(:whiskey).permit(:name, :proof, distiller_attributes: [:name, region_attributes: [:country]])
    end

end
