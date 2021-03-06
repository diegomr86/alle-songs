class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper, RockstarHelper, ActionView::Helpers::AssetUrlHelper

  before_action :set_view_path, :set_bot_vars, :set_page_title, :rockstar_init
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :set_csrf_cookie_for_ng

  USER_AGENTS = YAML.load(File.open(Rails.root.join(*['config', 'user_agents.yml']), 'r'))

  layout :set_layout

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def set_view_path
    prepend_view_path "#{Rails.root}/app/views/bot/" if is_bot?
    puts view_paths
  end

  def set_layout
    if is_bot?
      "application"
    else
      false
    end

  end

  def is_bot?
    USER_AGENTS.include?(request.user_agent) || params[:bot].present?
  end

  def set_bot_vars
    if is_bot?
      @top_tags = Rockstar::Tag.top_tags
    end
  end

  def set_page_title
    @head = {
        title: "AlleSongs | Music for everyone!",
        description: "Enjoy a nice music player experience online and free!",
        url: root_url,
        image: asset_url('logo.png')
    }
  end
end
