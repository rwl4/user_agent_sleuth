module UserAgentSleuth
  VALID_COMPARATORS = %w{ < > <= >= == != }

  AGENTS = {
    :safari  => /Version\/([0-9\.]+) Safari\/[0-9\.]+$/,
    :ie      => /MSIE ([0-9\.]+)/,
    :firefox => /Firefox\/([0-9\.]+)/,
    :chrome  => /Chrome\/([0-9\.]+)/,
    :opera   => /Opera\/[0-9\.]+.+Version\/([0-9\.]+)$/
  }

  class Parser
    def initialize(user_agent)
      @user_agent = user_agent
    end

    def method_missing(sym, *args, &block)
      agent_key = sym.to_s.gsub(/[^[:alnum:]]/,'').to_sym

      unless AGENTS.keys.include? agent_key
        return super(sym, *args, &block) 
      end

      agent_match?(AGENTS[agent_key], args.first)
    end

    def to_s
      @user_agent
    end

    private
    def version_match?(agent_version_string, query)
      comparator, version = parse_version_query(query)

      specified_version = version_string_to_f(version)
      agent_version = version_string_to_f(agent_version_string)

      # we only want to match up to the precision specified,
      # so a search for 10.5 should not match against 10.5.5
      # but instead just 10.5.
      precision = identify_precision(specified_version)
      version = agent_version.round(precision)

      # compare version against specified_version using the
      # specified comparator.
      version.send comparator, specified_version
    end

    def agent_match?(regex, version)
      match = @user_agent =~ regex

      return false unless match
      return true unless version

      version_match?($1, version)
    end

    def parse_version_query(query)
      query =~ /^([\<\>\!]{0,2}\=?)\s*([0-9\.]+)/
      comparator = $1
      version    = $2

      # the only case where our a user string should not match
      # our comparator list is for either blank or =, in which
      # case we just load it as ==.
      comparator = '==' unless VALID_COMPARATORS.include?(comparator)
      [comparator, version]
    end

    def identify_precision(version)
      version.to_s.split('.').last.length
    end

    def version_string_to_f(str)
      str_parts_with_index = str.split('.').each_with_index
      str_parts_with_index.reduce(0.0) do |sum, (n, index)|
        sum += n.to_f / (10000**index)
      end
    end
  end
end
