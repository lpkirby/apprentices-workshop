class HelpsController < ApplicationController
  before_action :authenticate_user!#, except: [:index]
  before_action :set_area, only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :set_help, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:new, :edit, :create, :update, :destroy] #[:show, :edit, :update, :destroy]

  respond_to :html

    def index
        @helps = @area.helps
    end

    def show

    end

    def new
        @help = @area.helps.build
    end

    def edit

    end

    def create
        @help = @area.helps.create(help_params)
        if @help.save
          @area.update(:last_updated_at => Time.now, :last_updated_by => current_user.id)
          redirect_to area_help_path(@area, @help), notice: 'Help was sucessfully created.'
        else
          render action: 'new'
        end
    end

    def update
        if @help.update(help_params)
          @area.update(:last_updated_at => Time.now, :last_updated_by => current_user.id)
          redirect_to area_help_path(@area, @help), notice: 'Help was sucessfully updated.'
        else
          render action: 'edit'
        end
    end

    def destroy
        @help.destroy
        if @help.save
          @area.update(:last_updated_at => Time.now, :last_updated_by => current_user.id)
          redirect_to area_helps_path(@area), notice: 'Help was sucessfully deleted.'
        else
          redirect_to area_helps_path(@area), notice: 'Something went wrong.'
        end
    end

    private
        def set_help
            @help = Help.find(params[:id])
        end

        def set_area
            @area = Area.find(params[:area_id])
        end

        def help_params
            params.require(:help).permit(:min_level, :keywords, :body )
        end

end
