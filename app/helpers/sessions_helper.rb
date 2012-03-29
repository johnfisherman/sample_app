module SessionsHelper
    # called on the sessions' controller, on create
    def sign_in(user)
      # add current user's remember token to cookie, that will last 20 yrs (permanent). So we can retrieve the user on subsequent page views.
      cookies.permanent[:remember_token] = user.remember_token
      # calls method current_user= . The purpose of this line is to create current_user, accessible in both controllers and views.
      # which will allow constructions such as <%= current_user.name %>
      current_user = user
    end
    
    def signed_in?
      # ¿ calls current_user getter, that in turn calls user_from_remember_token (if @current_user == nil), that checks for this user's remember_token cookie ?
      !current_user.nil?
    end
    
    # assignment definition
    def current_user=(user)
      # The one-line method body just sets an instance variable @current_user, effectively storing the user for later use.
      @current_user = user
    end
    
    # getter of instance variable, @current_user
    # guarantees states (from page to page user is seen as signed in, because token matches id)
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
