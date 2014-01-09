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
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
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
    puts ""
    puts "#{name}'s hand is:"
    cards.each do|card|
      puts "=> #{card}"
    end
    puts "=> For a total of #{total}."
  end

  def total
    face_values = cards.map{|card| card.face_value }
    total = 0

    face_values.each do |val|
      if val == "A"
        total += 11
      else total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    # correct for Aces
    face_values.select{|val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end
    total
  end

  def is_busted?
    total > Blackjack::BLACKJACK_AMOUNT
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

  def show_flop
    show_hand
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end

  def show_flop
    puts ""
    puts "The Dealer's hand is:"
    puts "=> First card is hidden."
    puts "=> #{cards[1]}"
  end
end

class Blackjack
  attr_accessor :deck, :player, :dealer

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17

  def initialize
    @deck = Deck.new
    @player = Player.new("Player1")
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

  def show_flop
    player.show_flop
    dealer.show_flop
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Dealer)
        puts "Sorry #{player.name}, the Dealer hit blackjack. You lose."
      else puts "Congratulations #{player.name}, you hit blackjack and won the game!"
      end
     play_again?
    elsif player_or_dealer.is_busted?
      if player_or_dealer.is_a?(Dealer)
        puts "Congratulations #{player.name}, the Dealer busted, so you win the game!"
      else puts "Sorry #{player.name}, you busted and lost the game."
      end
      play_again?
    end
  end

  def player_turn
    puts "It's #{player.name}\'s turn"

    blackjack_or_bust?(player)

    while !player.is_busted?
    puts "Would you like to (1) hit, or (2) stay?"
    hit_or_stay = gets.chomp

      if !['1', '2'].include?(hit_or_stay)
        puts 'Sorry, you must enter (1) to hit or (2) to stay.'
        next
      end

      if hit_or_stay == '2'
        puts "#{player.name} chose to stay. His total is #{player.total}."
        break
      end

      # if player wants to hit
      new_card = deck.deal_one
      player.add_card(new_card)

      puts "Dealing card to #{player.name}"
      puts "#{player.name}\'s next card is #{new_card}"
      puts "#{player.name}\'s total is now #{player.total}."

      blackjack_or_bust?(player)
    end
  end

  def dealer_turn
    puts ""
    puts "Dealer's turn"
    puts "The Dealer turns over his hidden card revealing #{dealer.cards[0]}"
    puts "The Dealer has a total of #{dealer.total}."

    blackjack_or_bust?(dealer)

    while dealer.total < DEALER_HIT_MIN
      new_card = deck.deal_one
      dealer.add_card(new_card)
      puts ""
      puts "Dealing card to Dealer, #{new_card}."
      puts "Dealer's total is now #{dealer.total}"

      blackjack_or_bust?(dealer)
    end
    puts "Dealer stays at #{dealer.total}."
  end

  def who_won?
    puts "#{player.name} has #{player.total}. The Dealer has #{dealer.total}."
    if player.total > dealer.total
      puts "Congratulations #{player.name}, you won!"
    elsif player.total < dealer.total
      puts "Sorry #{player.name}, you lose."
    else puts "It's a tie!"
    end
    play_again?
  end
  
  def play_again?
    puts ""
    puts "Do you want to (1) play again, or (2) quit?"
    if gets.chomp == '1'
      puts ""
      deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    else
      puts "Thanks for playing!"
      exit
    end
  end

  def start
    set_player_name
    deal_cards
    show_flop
    player_turn
    dealer_turn
    who_won?
  end
end

game = Blackjack.new
game.start