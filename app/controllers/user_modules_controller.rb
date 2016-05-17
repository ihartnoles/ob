class UserModulesController < ApplicationController
  # GET /user_modules
  # GET /user_modules.json
  def index
    @user_modules = UserModule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_modules }
    end
  end

  # GET /user_modules/1
  # GET /user_modules/1.json
  def show
    @user_module = UserModule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_module }
    end
  end

  # GET /user_modules/new
  # GET /user_modules/new.json
  def new
    @user_module = UserModule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_module }
    end
  end

  # GET /user_modules/1/edit
  def edit
    @user_module = UserModule.find(params[:id])
  end

  # POST /user_modules
  # POST /user_modules.json
  def create
    @user_module = UserModule.new(user_module_params)

    respond_to do |format|
      if @user_module.save
        format.html { redirect_to @user_module, notice: 'User module was successfully created.' }
        format.json { render json: @user_module, status: :created, location: @user_module }
      else
        format.html { render action: "new" }
        format.json { render json: @user_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_modules/1
  # PATCH/PUT /user_modules/1.json
  def update
    @user_module = UserModule.find(params[:id])

    respond_to do |format|
      if @user_module.update_attributes(user_module_params)
        format.html { redirect_to @user_module, notice: 'User module was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_modules/1
  # DELETE /user_modules/1.json
  def destroy
    @user_module = UserModule.find(params[:id])
    @user_module.destroy

    respond_to do |format|
      format.html { redirect_to user_modules_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def user_module_params
      params.require(:user_module).permit(:module, :module_id, :netid, :userid)
    end
end
