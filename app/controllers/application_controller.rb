class ApplicationController < ActionController::Base

  before_filter :redirect_domain_to if Rails.env.production?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private

    def redirect_domain_to
      domain_to_redirect_to = 'www.jodelstats.com'
      domain_exceptions = ['jodelstats.com', 'www.jodelstats.com']
      should_redirect = !(domain_exceptions.include? request.host)
      new_url = "#{request.protocol}#{domain_to_redirect_to}#{request.fullpath}"
      redirect_to new_url, status: :moved_permanently if should_redirect
    end

end
