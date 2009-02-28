# -*- coding: utf-8 -*-
require 'rubygems'
require 'highline'
require 'cgi'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 

module TermColor
  VERSION = '0.2.3'
  include REXML

  class ParseError < StandardError; end

  class << self
    def escape(text)
      CGI.escapeHTML(text)
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
      @result << HighLine.const_get(name.upcase)
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
