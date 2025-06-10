class ApplicationController < ActionController::API
  require 'jwt'

  SECRET_KEY = Rails.application.secret_key_base

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    begin
      decoded = JWT.decode(header, SECRET_KEY)[0]
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: "User not found: #{e.message}" }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: "Invalid token: #{e.message}" }, status: :unauthorized
    end
  end
end