# -*- coding: utf-8 -*-
require 'rubygems'
require 'highline'
require 'cgi'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 

module TermColor
  VERSION = '0.2.4'
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
      esc_seq = to_esc_seq(name)
      if esc_seq
        @result << esc_seq
        @tag_stack.push(name)
      end
    end

    def text(text)
      @result << CGI.unescapeHTML(text)
    end

    def tag_end(name)
      @tag_stack.pop
      @result << HighLine::CLEAR
      @result << to_esc_seq(@tag_stack[-1]) unless @tag_stack.empty?
    end

    def to_esc_seq(name)
      esc_seq = nil
      begin
        esc_seq = HighLine.const_get(name.upcase)
      rescue NameError
        if name =~ /^\d+$/
          esc_seq = "\e[#{name}m"
        end
      end
      esc_seq
    end
  end
end
