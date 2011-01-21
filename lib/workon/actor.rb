require 'workon/actor/base'
require 'workon/actor/text_mate'
require 'workon/actor/web_browser'
require 'workon/actor/finder'
require 'workon/actor/git'

module Workon
  module Actor
    def self.all
      Workon::Actor::Base.subclasses
    end
  end
end
