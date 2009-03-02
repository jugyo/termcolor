# -*- coding: utf-8 -*-
require 'rubygems'
require 'highline'
require 'cgi'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 

module TermColor
  VERSION = '0.2.6'
  include REXML

  class ParseError < StandardError; end

  class << self
    def parse(text)
      listener = MyListener.new 
      REXML::Parsers::StreamParser.new(text, listener).parse
      listener.result
    rescue REXML::ParseException => e
      raise ParseError, e
    end

    def escape(text)
      text.gsub(/[&<>'"]/) do | match |
        case match
          when '&' then '&amp;'
          when '<' then '&lt;'
          when '>' then '&gt;'
          when "'" then '&apos;'
          when '"' then '&quote;'
        end
      end
    end

    def unescape(text)
      text.gsub(/&(lt|gt|amp|quote|apos);/) do | match |
        case match
          when '&amp;' then '&'
          when '&lt;' then '<'
          when '&gt;' then '>'
          when '&apos;' then "'"
          when '&quote;' then '"'
        end
      end
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
