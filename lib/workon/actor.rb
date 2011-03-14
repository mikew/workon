module Workon
  module Actor
    include Enumerable
    
    def self.each(&block)
      Workon::Actor::Base.subclasses.each {|c| yield c }
    end
    
    def self.before(actor = nil, other = nil)
      @before ||= {}
      
      return @before if actor.nil?
      raise ArgumentError if other.nil?
      
      @before[other] = actor
    end
    
    def self.ordered
      order ||= Workon::Actor::Base.subclasses.inject([]) do |memo, klass|
        finder      = klass.name.split('::').last
        other       = before[finder.to_sym]
        should_add  = !Workon.config[:without].include?(finder) && !memo.include?(klass)
        
        should_add ? memo + (other ? [other, klass] : [klass]) : memo
      end
    end
  end
end

require 'workon/actor/base'
require 'workon/actor/text_mate'
require 'workon/actor/web_browser'
require 'workon/actor/finder'
require 'workon/actor/git'
require 'workon/actor/watchr'
require 'workon/actor/passenger'
require 'workon/actor/middleman'
