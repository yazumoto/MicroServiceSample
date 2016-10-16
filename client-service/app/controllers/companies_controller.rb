class CompaniesController < ApplicationController
  def index
    response = conn.get do |req|
      req.url '/companies'
      req.headers['AUTHORIZATION'] = "Bearer #{access_token}"
    end
    render json: response.body
  end

  private

  def conn
    @conn ||= Faraday.new(url: 'http://lvh.me:5000') do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def access_token
    ENV['ACCESS_TOKEN']
  end
end
