class Api::V1::ViewingPartiesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: ErrorSerializer.format_error(ErrorMessage.new(e.message, 404)), status: :not_found
  end

  def create
    movie = MovieGateway.get_movie(params[:movie_id])

    if DateTime.parse(params[:start_time]) + movie.runtime.minutes > DateTime.parse(params[:end_time])
      render json: ErrorSerializer.format_error(ErrorMessage.new("Party must last long enough for the entire movie", 400)), status: :bad_request
      return
    end

    User.find(params[:user_id])
    viewing_party = ViewingParty.new(viewing_party_params)
    if viewing_party.save
      params[:invitees].each do |user_id|
        viewing_party.viewing_party_users.create(user_id: user_id)
      end
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(viewing_party.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def update
    host = User.find(params[:user_id])
    viewing_party = ViewingParty.find(params[:id])
    invitee = User.find(params[:invitees_user_id])

    if viewing_party.user.id != host.id
      render json: ErrorSerializer.format_error(ErrorMessage.new("User is not host", 401)), status: :unauthorized
      return
    end

    viewing_party.users << invitee
    render json: ViewingPartySerializer.new(viewing_party), status: :ok
  end

  private

  def viewing_party_params
    params.permit(:name, :start_time, :end_time, :movie_id, :movie_title, :invitees, :user_id)
  end
end
