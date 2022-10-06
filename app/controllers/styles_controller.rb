class StylesController < ApplicationController
    before_action :ensure_that_signed_in, except: [:index, :show]
  
    def index
      @styles = Style.all
      @beers = Beer.all
    end
  
    def new
      @style = Style.new
    end
  
    def create
      @style = Style.create params.require(:style).permit(:name, :description)
  
      if @style.save
        redirect_to style_path
      else
        @styles = Style.all
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      style = Styles.find(params[:id])
      redirect_to styles_path
    end
  end
  