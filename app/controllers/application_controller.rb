class ApplicationController < ActionController::Base
  protect_from_forgery
  # We could make an entirely new module for authentication, but the Sessions controller 
  # already comes equipped with a module, namely, SessionsHelper. Moreover, such helpers are automatically included in Rails views, 
  # so all we need to do to use the Sessions helper functions in controllers is to include the module into the Application controller
  include SessionsHelper
end
