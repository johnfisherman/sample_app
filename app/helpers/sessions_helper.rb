module SessionsHelper
    # called on the sessions' controller, on create
    def sign_in(user)
      # add current user's remember token to cookie, that will last 20 yrs (permanent). So we can retrieve the user on subsequent page views.
      cookies.permanent[:remember_token] = user.remember_token
      current_user = user
    end
    
    def signed_in?
      !current_user.nil?
    end
    
    # assignment definition
    def current_user=(user)
      @current_user = user
    end
    
    def current_user
      # calls the user_from_remember_token method the first time current_user is called, but on subsequent invocations 
      # returns @current_user without calling user_from_remember_token. This is only useful if current_user is used more than once for a single user request; 
      # in any case, user_from_remember_token will be called at least once every time a user visits a page on the site.
      @current_user ||= user_from_remember_token
    end
      
    def sign_out
      current_user = nil
      cookies.delete(:remember_token)
    end  
      
      
    private
      # retrieve current user from remember token created on sign up
      # called at least once every time a user visits a page on the site
      def user_from_remember_token
        remember_token = cookies[:remember_token]
        User.find_by_remember_token(remember_token) unless remember_token.nil?
      end    
    
end
