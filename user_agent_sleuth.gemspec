require File.expand_path("../lib/user_agent_sleuth/version", __FILE__)

Gem::Specification.new do |s|
s.name        = "user_agent_sleuth"
s.version     = UserAgentSleuth::VERSION
s.platform    = Gem::Platform::RUBY
s.authors     = ["Raymond W. Lucke IV"]
s.email       = ["ray@raylucke.com"]
s.homepage    = "http://github.com/rwl4/user_agent_sleuth"
s.summary     = "Painless user agent indentification for Rails"
s.description = "Extends the request.user_agent to allow for simple questions such as request.user_agent.ie?"
s.required_rubygems_version = ">= 1.3.6"

# required for validation
s.rubyforge_project         = "user_agent_sleuth"

# If you need to check in files that aren't .rb files, add them here
s.files        = Dir["{lib}/**/*.rb", "MIT-LICENSE", "README"]
s.require_path = 'lib'
end

