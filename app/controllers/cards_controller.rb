class CardsController < ApplicationController
  def show
    @card = Rails.cache.fetch("card_#{params[:id]}", expires_in: 1.day) do
      Trello::Card.find(params[:id])
    end
  end
end
