require 'user_agent_sleuth/parser'

module UserAgentSleuth
  class << self
    def enable
      return if ActionDispatch::Request.instance_methods.include? :user_agent_with_search
      ActionDispatch::Request.send :include, UserAgentSleuth
    end
  end

  def self.included(base)
    base.alias_method_chain :user_agent, :search
  end

  def user_agent_with_search
    Parser.new(user_agent_without_search)
  end
end

if defined? Rails
  UserAgentSleuth.enable
end
