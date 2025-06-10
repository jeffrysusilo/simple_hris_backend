class ProtectedTestController < ApplicationController
  before_action :authorize_request

  def secret
    render json: { message: "Hello, #{@current_user.name}. Kamu berhasil akses!" }
  end
end
