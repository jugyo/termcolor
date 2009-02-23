require 'highline'
require 'cgi'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 

class TermColor
  VERSION = '0.0.1'
  include REXML

  class ParseError < StandardError; end

  class << self
    @highline = HighLine.new
    def print(text)
      print parse(text)
    end

    def parse(text)
      listener = MyListener.new 
      REXML::Parsers::StreamParser.new(text, listener).parse
      listener.result
    rescue REXML::ParseException => e
      raise ParseError, e
    end
  end

  class MyListener 
    include REXML::StreamListener 

    attr_reader :result
    def initialize
      @result = ''
      @tag_stack = []
    end

    def tag_start(name, attrs)
      esc_seq = HighLine.const_get(name.upcase)
      @result << esc_seq
      @tag_stack.push(name)
    rescue NameError
    end

    def text(text)
      @result << CGI.unescapeHTML(text)
    end

    def tag_end(name)
      @tag_stack.pop
      @result << HighLine::CLEAR
      @result << HighLine.const_get(@tag_stack[-1].upcase) unless @tag_stack.empty?
    end

  end
end
