require "pry"

puts 'Welcome to the blackjack game. What is your name?'
player_name = gets.chomp
puts 'Thanks for playing ' + player_name.capitalize + '!' + 'Let\'s play!'

cards = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', 'Jack', 'Queen', 'King']
suits = ['clubs', 'diamonds', 'hearts', 'spades']

deck = cards.product(suits)

deck_shuffled = deck.shuffle!

puts deck_shuffled[0].join

player_hand = []
dealer_hand = []

player_first_card = deck_shuffled[0]

puts player_first_card[0][0] + 'of' + player_first_card[0][1]

# puts 'Your first card is a ' + player_first_card[0][0].to_s + 'of' + player_first_card[0][1] + '.'
# player_hand << player_first_card.pop


# dealer_first_card = deck_shuffled[0].to_s
# puts 'The dealer\'s first card is a ' + deck_shuffled[0].to_s + '.'
# dealer_hand << dealer_first_card.pop

