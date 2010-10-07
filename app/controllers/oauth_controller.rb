class OauthController < ApplicationController
  before_filter :authenticate_user!, :except => [:access_token]
  skip_before_filter :verify_authenticity_token, :only => [:access_token, :user]

  def authorize
    AccessGrant.prune!
    access_grant = current_user.access_grants.create(:application => application)
    redirect_to access_grant.redirect_uri_for(params[:redirect_uri])
  end

  def access_token
    access_grant = AccessGrant.find_by_code(params[:code])
    if access_grant
      access_grant.start_expiry_period!
      render :json => {:access_token => access_grant.access_token, :refresh_token => access_grant.refresh_token, :expires_in => access_grant.access_token_expires_at}
    else
      render :json => {:error => "Could not authenticate access code"}
    end
  end

  def user
    render :json => current_user.to_json
  end

  protected
    def application
      @application ||= ClientApplication.find_by_app_id(params[:client_id])
    end
end