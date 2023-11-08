class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_destroyed

  private
  def not_destroyed(e)
    render json: { messages: "Book not destroyed", errors: e.to_s }, status: :unprocessable_entity
  end

  def authenticate_request!
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
