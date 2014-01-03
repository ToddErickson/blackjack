require 'rubygems'
require 'pry'

class Card
  attr_accessor :suit, :face_value

  def initialize(s,fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    "A #{face_value} of #{find_suit}."
  end

  def to_s
    pretty_output
  end

  def find_suit
    ret_val = case suit
                when 'H' then 'Hearts'
                when 'D' then 'Diamonds'
                when 'S' then 'Spades'
                when 'C' then 'Clubs'
              end
    ret_val
  end
end

class Deck

  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end  
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand

  def show_hand
    puts "#{name}'s hand is:"
    cards.each do|card|
      puts "=> #{card}"
    end
    puts "=> The total is #{total}."
  end

  def total
    face_values = cards.map{|card| card.face_value }
    total = 0

    face_values.each do |val|
      if val == "Ace"
        total += 11
      else total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    # correct for Aces
    face_values.select{|val| val == "Ace"}.count.times do
      break if total <= 21
      total -= 10
    end
    total
  end

  def is_busted?
    total > 21
  end    

  def add_card(new_card)
    cards << new_card
  end
end

class Player
  include Hand
  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end

#need an -engine- to run the gameplay
class Blackjack
  attr_accessor :deck, :player, :dealer

  def initialize
    @deck = Deck.new
    @player = Player.new("Player Name")
    @dealer = Dealer.new
  end

  def set_player_name
    puts "What is your name?"
    player.name = gets.chomp
  end

  def deal_cards
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
    player.add_card(deck.deal_one)
    dealer.add_card(deck.deal_one)
  end

  def show_hands
    # use module show_hand method
    player.show_hand
    dealer.show_hand
  end

  def start
    # what are the behaviours or actions that we need in the game play
    # use these game play behaviours or actions to create the Blackjack class methods
    set_player_name
    deal_cards
    show_hands
    #player_turn
    #dealer_turn
    #who_won?(player, dealer)
  end
end

game = Blackjack.new
game.start