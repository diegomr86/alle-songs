class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper, RockstarHelper

  before_action do
    @tracks = Track.where(session_id: request.session_options[:id])
  end

end
