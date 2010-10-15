class OauthController < ApplicationController
  before_filter :authenticate_user!, :except => [:access_token]
  skip_before_filter :verify_authenticity_token, :only => [:access_token, :user]

  def authorize
    AccessGrant.prune!
    access_grant = current_user.access_grants.create(:application => application)
    redirect_to access_grant.redirect_uri_for(params[:redirect_uri])
  end

  def access_token
    application = ClientApplication.authenticate(params[:client_id], params[:client_secret])
    
    if application.nil?
      render :json => {:error => "Could not find application"}
      return
    end
    
    access_grant = AccessGrant.authenticate(params[:code], application.id)
    
    if access_grant.nil?
      render :json => {:error => "Could not authenticate access code"}
      return
    end
    
    access_grant.start_expiry_period!
    render :json => {:access_token => access_grant.access_token, :refresh_token => access_grant.refresh_token, :expires_in => access_grant.access_token_expires_at}
  end

  def user
    render :json => current_user.to_json
  end

  protected
    def application
      @application ||= ClientApplication.find_by_app_id(params[:client_id])
    end
end