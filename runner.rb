require "bundler/setup"
require "gaminator"
require File.expand_path('ascii_boxing_game')

Gaminator::Runner.new(ASCIIBoxing::Game, :rows => 30, :cols => 80).run
