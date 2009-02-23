require "rexml/document"

class TermColor
  VERSION = '0.0.1'

  class << self
    @highline = HighLine.new
    def print(text)
      print parse(text)
    end
    def parse(text)
      # TODO
    end
  end
end
