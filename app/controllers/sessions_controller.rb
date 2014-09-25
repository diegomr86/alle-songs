class SessionsController < Devise::SessionsController
  skip_before_filter :require_no_authentication

  def create
  resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
  sign_in_and_redirect(resource_name, resource)
end

  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    return render :json => {:success => true, data: resource}
  end

  def failure
    return render :json => {:success => false, :errors => [I18n.t("devise.failure.invalid")]}, status: 422
  end
end