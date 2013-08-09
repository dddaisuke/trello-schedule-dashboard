class DashboardController < ApplicationController
  def index
    board = Rails.cache.fetch('trello_board', expires_in: 1.day) do
      Trello::Board.find(BoardStatus::BoardId)
    end

    members = Rails.cache.fetch('trello_members', expires_in: 1.day) do
      board.members
    end
    @member_by_id = {}
    members.each do |member|
      @member_by_id[member.id] = member.full_name
    end

    @lists = {}
    @list_name_by_id = {}
    # list -> member -> card
    lists = Rails.cache.fetch('trello_lists', expires_in: 1.day) do
      board.lists
    end
    lists.each do |list|
      @list_name_by_id[list.id] = list.name
      cards_by_member = @lists[list.id]
      unless cards_by_member
        cards_by_member = {}
        @lists[list.id] = cards_by_member
      end

      cards = Rails.cache.fetch("trello_cards_#{list.id}", expires_in: 1.day) do
        list.cards
      end
      cards.each do |card|
        Rails.cache.write("card_#{params[:id]}", card, expires_in: 1.day)
        card_data = card_data(card)
        card_member_ids = Rails.cache.fetch("trello_card_member_ids_#{card.id}", expires_in: 1.day) do
          card.member_ids
        end
        card_member_ids.each do |member_id|
          cards_by_member = @lists[list.id]

          cards = cards_by_member[member_id]
          unless cards
            cards = []
            cards_by_member[member_id] = cards
          end
          cards << card_data
        end
      end
    end
    @selected_list_id = params[:list_id] || @lists.keys.first
    @selected_list = @lists[@selected_list_id]
  end

  private

  def card_data(card)
    data = card.name.split('@')
    name = data.first
    time = data.second if data.count > 1
    time_as_integer = 1
    if time
      word = time.slice(time.size - 1, time.size)
      case word
      when 'h'
        time_as_string = time.slice(0, time.size - 1)
        time_as_integer = (time_as_string.to_f / 24).ceil
      when 'd'
        time_as_string = time.slice(0, time.size - 1)
        time_as_integer = time_as_string.to_i
      end
    end

    { name: name, time: time_as_integer, url: card.url, id: card.id }
  end
end
