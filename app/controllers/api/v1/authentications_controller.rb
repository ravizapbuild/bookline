module Api
  module V1
    class AuthenticationsController < ApplicationController
      before_action :authorize_request, except: :login
      rescue_from ActionController::ParameterMissing, with: :missing_params

      # POST /auth/login
      def login
        if params.require(:email) and params.require(:password)
          @user = User.find_by_email(params[:email])
          if @user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: @user.id)
            time = Time.now + 24.hours.to_i
            render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                          email: @user.email }, status: :ok
          else
            render json: { error: "unauthorized" }, status: :unauthorized
          end
        end
      end

      private
      def login_params
        params.permit(:email, :password)
      end

      private
      def missing_params(e)
        render json: { error: e.message }, status: :unprocessable_entity
      end

    end
  end
end
