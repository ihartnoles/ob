class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    authenticate_for_useradmin(session[:cas_user])

    # if @access == 1
      @users = User.order(:netid).all

      # respond_to do |format|
      #   format.html # index.html.erb
      #   format.json { render json: @users }
      # end
    # else
    #     redirect_to unauthorized_path and return
    # end

    render layout: 'admin'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    # respond_to do |format|
    #   format.html # new.html.erb
    #   #format.json { render json: @user }
    # end

    render layout: 'admin'
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    render layout: 'admin'
  end

  # POST /users
  # POST /users.json
  def create
    #@user = User.new(params[:user])
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end    
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    #redirect_to users_url
     respond_to do |format|
       format.html { redirect_to users_url }
       format.json { head :no_content }
     end
  end

  
  private

  def user_params
      params.require(:user).permit(:id, :module, :module_id, :access_level, :netid, :created_at, :updated_at)
  end


  protected

   def authenticate_for_useradmin(netid)
      user = User.where(:netid => netid, :access_level => 'admin')
      if user.count == 0 #no info found
         redirect_to(unauthorized_path) and return
      end       
   end 


end
