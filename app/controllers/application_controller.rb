class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :authenticate, :except => ['intro','login','logout','signup','getjob']
  before_filter :authorize, :except => ['intro','login','logout','signup','dashboard','getjob']

  def checkAdmin
    if @current_user.name == "Admin" and @current_user.id == 1 and @current_account.name == "Admin" and @current_account.id == 1
      logger.info("Admin is accessing resource #{controller_name} #{action_name}")
    else
      flash[:error] = "Access denied"
      redirect_to :controller => 'home', :aciton => 'dashboard'
    end
  end


  def addToAccount(thing, value)
    eval "@current_account.#{thing} << value"
  end
 
  def removeFromAccount(thing, value)
    eval "@current_account.#{thing}.delete value"
  end

  def checkObjectOwner(thing, value)
    if not @current_user.name == "Administrator"
      eval "if not @current_account.#{thing}.include? value
              flash[:error] = \"Access Denied\"
              redirect_to :controller => \'/home\', :action => \'dashboard\'
            end"
    end
  end

private

  def authenticate
    Session.sweep
    logger.debug("Authenticate of #{session[:user_id].to_s}")
    if not User.find_by_id(session[:user_id])
      flash[:notice] = "Please Log In First"
      redirect_to "/"
    else
      @current_user = User.find(session[:user_id])
      @current_account = Account.find(session[:account_id])
    end
  end

  def authorize
    logger.debug("#{@current_user.username} and account #{@current_account.name}")
    @current_user.roles.each do |r|
      logger.debug("Looking Role for User #{@current_user.username}")
      logger.debug("#{r.name}")
    end
    a = ""
    arr1 = []
    arr2 = []
    case action_name
      when "create"
        a = "c"
      when "show"
        a = "r"
      when "edit"
        a = "r"
      when "update"
        a = "u"
      when "destroy"
        a = "d"
      else
        return true
    end
    res = controller_name.singularize.camelize
    arr1 = @current_user.roles.map(&:id)
    logger.debug("#{arr1}")
    if Permission.find_by_key("#{a}-#{controller_name.singularize}").nil?
      flash[:notice] = "The resource you are tryting to access do not have permissions assigned, contact the Administrator"
      redirect_to :controller => '/home', :action => 'dashboard'
      return
    end
    arr2 = Permission.find_by_key("#{a}-#{controller_name.singularize}").roles.map(&:id)
   if arr1.nil? or arr2.nil?
     flash[:notice] = "You don't have enough privileges for doing this"
     redirect_to :controller => '/home', :action => 'dashboard'
     return
   end
   access = arr1 & arr2
   if !access.empty?
     logger.debug(access.to_s)
     logger.debug("This action should have been allowed")
     return
   else
     logger.debug("You dont have enough privileges for doing this")
     logger.debug("This Action should've been denied")
     flash[:notice] = "You dont have enough privileges for doing this"
     redirect_to :controller => '/home', :action => 'dashboard'
     return
   end
  end

end
