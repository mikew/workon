module Workon
  module Actor
    autoload :Helpers, 'workon/actor/helpers'

    def self.each(&block)
      Base.subclasses.each {|c| yield c }
    end

    def self.before(actor = nil, other = nil)
      @before ||= Hash.new { [] }

      return @before if actor.nil?
      raise ArgumentError if other.nil?

      @before[other] += [actor]
    end

    def self.ordered
      order ||= Base.subclasses.inject([]) do |memo, klass|
        other       = encompass klass
        should_add  = !memo.include?(klass)

        should_add ? memo + other : memo
      end

      order
    end

    def self.encompass(klass)
      finder  = klass.actor_name.to_sym
      _before = before[finder].map {|k| encompass k }

      (_before + [klass]).flatten
    end
  end
end

require 'workon/actor/base'
require 'workon/actor/editor'
require 'workon/actor/web_browser'
require 'workon/actor/finder'
require 'workon/actor/git'
require 'workon/actor/watchr'
require 'workon/actor/guard'
require 'workon/actor/server'
