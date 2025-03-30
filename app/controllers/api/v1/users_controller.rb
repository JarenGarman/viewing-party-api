class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: ErrorSerializer.format_error(ErrorMessage.new("Invalid User ID", 404)), status: :not_found
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user, {fields: {user: [:name, :username, :api_key]}}), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def index
    render json: UserSerializer.new(User.all, {fields: {user: [:name, :username]}})
  end

  def show
    render json: UserSerializer.new(User.find(params[:id]), {fields: {user: [:name, :username, :viewing_parties_hosted, :viewing_parties_invited]}})
  end

  private

  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end
end
