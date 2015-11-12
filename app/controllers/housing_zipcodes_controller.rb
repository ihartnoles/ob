class HousingZipcodesController < ApplicationController
  before_action :set_housing_zipcode, only: [:show, :edit, :update, :destroy]

  # # GET /housing_zipcodes
  # # GET /housing_zipcodes.json
  # def index
  #   @housing_zipcodes = HousingZipcode.all
  # end

  # # GET /housing_zipcodes/1
  # # GET /housing_zipcodes/1.json
  # def show
  # end

  # # GET /housing_zipcodes/new
  # def new
  #   @housing_zipcode = HousingZipcode.new
  # end

  # # GET /housing_zipcodes/1/edit
  # def edit
  # end

  # # POST /housing_zipcodes
  # # POST /housing_zipcodes.json
  # def create
  #   @housing_zipcode = HousingZipcode.new(housing_zipcode_params)

  #   respond_to do |format|
  #     if @housing_zipcode.save
  #       format.html { redirect_to @housing_zipcode, notice: 'Housing zipcode was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @housing_zipcode }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @housing_zipcode.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /housing_zipcodes/1
  # # PATCH/PUT /housing_zipcodes/1.json
  # def update
  #   respond_to do |format|
  #     if @housing_zipcode.update(housing_zipcode_params)
  #       format.html { redirect_to @housing_zipcode, notice: 'Housing zipcode was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @housing_zipcode.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /housing_zipcodes/1
  # # DELETE /housing_zipcodes/1.json
  # def destroy
  #   @housing_zipcode.destroy
  #   respond_to do |format|
  #     format.html { redirect_to housing_zipcodes_url }
  #     format.json { head :no_content }
  #   end
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_housing_zipcode
  #     @housing_zipcode = HousingZipcode.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def housing_zipcode_params
  #     params.require(:housing_zipcode).permit(:zip, :city, :state, :county, :campus, :distance)
  #   end
end
