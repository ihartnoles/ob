class ModuledatesController < ApplicationController
  # GET /moduledates
  # GET /moduledates.json

  before_filter :authenticate_for_admin
  def index
    @moduledates = Moduledate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @moduledates }
    end
  end

  # GET /moduledates/1
  # GET /moduledates/1.json
  def show
    @moduledate = Moduledate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @moduledate }
    end
  end

  # GET /moduledates/new
  # GET /moduledates/new.json
  def new
    @moduledate = Moduledate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @moduledate }
    end
  end

  # GET /moduledates/1/edit
  def edit
    @moduledate = Moduledate.find(params[:id])
  end

  # POST /moduledates
  # POST /moduledates.json
  def create
    @moduledate = Moduledate.new(moduledate_params)

    respond_to do |format|
      if @moduledate.save
        format.html { redirect_to @moduledate, notice: 'Moduledate was successfully created.' }
        format.json { render json: @moduledate, status: :created, location: @moduledate }
      else
        format.html { render action: "new" }
        format.json { render json: @moduledate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /moduledates/1
  # PATCH/PUT /moduledates/1.json
  def update
    @moduledate = Moduledate.find(params[:id])

    respond_to do |format|
      if @moduledate.update_attributes(moduledate_params)
        format.html { redirect_to @moduledate, notice: 'Moduledate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @moduledate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moduledates/1
  # DELETE /moduledates/1.json
  def destroy
    @moduledate = Moduledate.find(params[:id])
    @moduledate.destroy

    respond_to do |format|
      format.html { redirect_to moduledates_url }
      format.json { head :no_content }
    end
  end

   protected

   def authenticate_for_admin
      user = User.where(:netid => session[:cas_user])
      if user.count == 0 #no info found
       redirect_to unauthorized_path
      end       
   end 


  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def moduledate_params
      params.require(:moduledate).permit(:closedate, :name, :opendate, :termvalue)
    end
end
