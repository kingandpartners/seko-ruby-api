module Seko
  class Filter

    def self.parse(text)
      text.gsub('|', '-')
    end

  end
end