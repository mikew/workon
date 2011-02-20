require 'workon/actor/base'
require 'workon/actor/text_mate'
require 'workon/actor/web_browser'
require 'workon/actor/finder'
require 'workon/actor/git'
require 'workon/actor/watchr'
require 'workon/actor/passenger'

module Workon
  module Actor
    include Enumerable
    
    def self.each(&block)
      Workon::Actor::Base.subclasses.each {|c| yield c }
    end
  end
end
