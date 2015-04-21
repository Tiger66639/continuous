class HomeController < ApplicationController
  def login
    if request.post?
      logger.debug("STARTING LOGIN")
      logger.debug(params[:username])
      logger.debug(params[:password])
      account = Account.find_by_name("continuous_#{params[:username]}")
      if account.nil?
        logger.debug("Account doesnt exist")
        logger.debug("Checking if user exists in LDAP")
        new_user = User.new
        new_user.username = params[:username]
        new_user.password = params[:password]
        if new_user.authUserLDAP
          logger.debug("User exists in ldap")
          new_user.email = new_user.ldapGetEmail
          new_user.uuid = new_user.setUuid
          new_user.name = new_user.ldapGetName
	  logger.debug("LOOKING FOR DATA IN LDAP")
          logger.debug(new_user.email)
          logger.debug(new_user.uuid)
          logger.debug(new_user.name)
          new_account = Account.new
          new_account.name = "continuous_#{params[:username]}"
          new_account.uuid = new_account.setUuid
          if new_account.save
            if new_user.save
              logger.debug("Created new account and user #{params[:username]}")
              new_account.users << new_user
              new_user.roles << Role.find_by_name("Developer")
              session[:user_id] = new_user.id
              session[:account_id] = new_account.id
              flash[:notice] = "Welcome user #{new_user.name}"
              redirect_to :action => 'dashboard'
              return
            else
              logger.debug("User could not be saved destroying account")
              new_account.destroy
              session[:user_id] = nil
              session[:account_id] = nil
              flash[:notice] = "Error while creating new user"
              redirect_to :action => 'login'
              return
            end
          else
            session[:user_id] = nil
            session[:account_id] = nil
            logger.debug("Erro while creating new account")
            flash[:notice] = "Error while creating new account"
            redirect_to :action => 'login'
            return
          end          
        else
          session[:user_id] = nil
          session[:account_id] = nil
          logger.debug("User does not exist in ldap")
          flash[:notice] = "Error user does not exist in LDAP"
          redirect_to :action => 'login'
          return  
        end         
      else
        logger.debug("Account exist")
        user = User.find_by_username(params[:username])
        if not user.nil?
          user.password = params[:password]
          if user.password == Continuous::Application.config.adminpassword and user.id == 1 and user.name == "Admin" and account.id == 1 and account.name == "Admin"
            logger.debug("Admin entering the rEALM")
            session[:user_id] = 1
            session[:account_id] = 1
            redirect_to :action => 'dashboard'
            return 
          else
            if user.authUserLDAP
	      logger.debug("User authenticated")
              session[:user_id] = user.id
              session[:account_id] = account.id
              logger.debug("user id #{session[:user_id]} and account #{session[:account_id]}")
              redirect_to :action => 'dashboard'
              return
            else
              session[:user_id] = nil
              session[:account_id] = nil
              flash[:notice] = 'Wrong Password'
              redirect_to :action => 'login'
              return
            end
          end
        else
          session[:user_id] = nil
          session[:account_id] = nil
          flash[:notice] = 'Wrong Username'
          redirect_to :action => 'login'
          return
        end
      end
    else
      render layout: "blank"
    end
  end

  def logout
    session[:user_id] = nil
    session[:account_id] = nil
    redirect_to "/"
  end

  def dashboard
    @validationDashboard = Dashboard.all.size
    @allDeploy = Deploy.all.size
    @okDeploy = Deploy.where("status = ?", "SUCCESS").size.to_f / @allDeploy.to_f * 100.0
    @errorDeploy = Deploy.where("status = ?", "ERROR").size.to_f / @allDeploy.to_f * 100.0
  end

  def messages
  end

  def alerts
  end

  def tasks
  end

  def account
    @account = Account.find_by_id(@current_account)
    @users = User.all
    @account_users = @current_account.users
  end

  def user
    @user = User.find_by_id(@current_user)
  end

  def changeaccount
    nextaccount = params[:id]
    if @current_user.account_ids.include? nextaccount.to_i
      session[:account_id] = nextaccount
    end
    redirect_to :controller => "home", :action => 'dashboard'
  end

  def adduser
    useradded = params[:user_id]
    logger.info("Adding user")
    logger.info(useradded)
    if not @current_account.user_ids.include? useradded.to_i
      begin
        n = User.find(useradded)
        @current_account.users << n
        flash[:notice] = "User #{n.username} added to your account"
      rescue
        flash[:notice] = "User to invite not found"
      end
    end
    redirect_to :controller => 'home', :action => 'dashboard'
  end

  def deleteuser
    deleteuser = params[:id]
    if @current_account.user_ids.include?(deleteuser.to_i) and @current_user.id != deleteuser.to_i
      begin
        n = User.find(deleteuser)
        @current_account.users.delete(n)
        flash[:notice] = "User #{n.username} removed from this account"
      rescue
        flash[:notice] = "User to removed not found"
      end
    end
    redirect_to :controller => 'home', :action => 'dashboard'
  end

end
