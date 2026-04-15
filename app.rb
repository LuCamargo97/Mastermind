# frozen_string_literal: true

require 'sinatra'
require 'zeitwerk'

# rubocop:disable Layout/LineLength
SESSION_SECRET = '33ad1c97fd678d67f6ae8dc3d0817e3c1618d0b45091ceb0091bcba034fc90fae9d40af64d419540d89dcdfd84d13b369780c7a6dab83f58359d345c98147b00'
# rubocop:enable Layout/LineLength

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
loader.setup

enable :sessions
set :session_secret, SESSION_SECRET

get '/' do
  session[:game] ||= Game.new
  @game = session[:game]

  erb :index
end

post '/guess' do
  @game = session[:game]
  user_guess = params[:colors].map(&:to_sym)

  @game.play_attempt(user_guess)

  session[:game] = @game
  redirect '/'
end

post '/reset' do
  session[:game] = Game.new
  redirect '/'
end
