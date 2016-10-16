class CompaniesController < ApplicationController
  before_action :require_authorization
  def index
    render json: Company.all
  end

  private

  def require_authorization
    if !authorization_verification.success?
      render :nothing, status: :unauthorized
    elsif scopes.exclude?('view_companies')
      render :nothing, status: :unauthorized
    end
  end

  def scopes
    @scopes ||= JSON.parse(authorization_verification.body)['scopes']
  end

  def authorization_verification
    @authorization_verification ||= conn.get do |req|
      req.url '/oauth/token/info'
      req.headers['AUTHORIZATION'] = "Bearer #{access_token}"
    end
  end

  def conn
    @conn ||= Faraday.new(url: 'http://localhost:3000') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def access_token
    @access_token ||= request.headers['AUTHORIZATION'].match(/Bearer (.*)/).captures[0]
  end
end
