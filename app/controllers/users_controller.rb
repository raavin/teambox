class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :find_user, :only => [ :show ]
  
  skip_before_filter :login_required, :only => [ :new, :create ]
  skip_before_filter :load_project
  
  def index
  end

  # render new.rhtml
  def new
    @user = User.new
    render :layout => 'login'
  end

  def show
    @visible_activities = @user.activities_visible_to_user @current_user
    options = { :only => [:id, :login, :name, :language, :email, 'time-zone', 'created-at', 'updated-at'] }
    respond_to do |format|
      format.html
      format.xml { render :xml => @user.to_xml(options) }
      format.json { render :json => @user.to_json(options) }
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_user = @user # !! now logged in
      redirect_to contact_importer_users_path
      flash[:notice] = "Thanks for signing up!"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => :new, :layout => 'login'
    end
  end
  
  def update
    @current_user.update_attributes(params[:user])
    if @current_user.save
      flash[:error] = nil
      flash[:success] = "User profile updated!"
    else
      flash[:success] = nil
      flash[:error] = "Couldn't save the updated profile. Please correct the mistakes and retry."
    end
    render :action => :edit
  end
  
  def contact_importer
    
  end

  def comments_ascending
    @current_user.update_attribute(:comments_ascending,true)

    respond_to do |format|
      format.js
    end
  end

  def comments_descending
    @current_user.update_attribute(:comments_ascending,false)

    respond_to do |format|
      format.js
    end
  end
  
  def conversations_first_comment
    @current_user.update_attribute(:conversations_first_comment,true)

    respond_to do |format|
      format.js
    end
  end

  def conversations_latest_comment
    @current_user.update_attribute(:conversations_first_comment,false)

    respond_to do |format|
      format.js
    end
  end  
  
  def invitations
  end
  
  private
    def find_user
      @user = User.find_by_id(params[:id])
    end

end