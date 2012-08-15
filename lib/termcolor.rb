# -*- coding: utf-8 -*-
require 'rubygems'
require 'highline'
require 'cgi'
require 'rexml/parsers/streamparser' 
require 'rexml/parsers/baseparser' 
require 'rexml/streamlistener' 

module TermColor
  VERSION = '1.2.2'
  include REXML

  class << self
    def parse(text)
      listener = MyListener.new 
      REXML::Parsers::StreamParser.new(prepare_parse(text), listener).parse
      listener.result
    end

    def escape(text)
      escape_or_unescape(:escape, text)
    end

    def unescape(text)
      escape_or_unescape(:unescape, text)
    end

    def escape_or_unescape(dir=:escape, text)
      h = Hash[*%w(& &amp; < &lt; > &gt; ' &apos; " &quot;)]
      h = h.invert if dir == :unescape
      text.gsub(/(#{h.keys.join('|')})/){ h[$1] }
    end
    private :escape_or_unescape

    def prepare_parse(text)
      tag_separate text.gsub(/<(\/?)(\d+)>/, '<\1_\2>')
    end

    def tag_separate(text)
      re = /<(\/*)([^\W_]+)(?:_(on_[^\W_]+))*(?:_with_([^\W_]+))*(?:_and_([^\W_]+))*>/
      text.gsub(re) do
        matchs = $~.captures
        if matchs.shift.empty?
          tag = ->t{ "<#{t}>" }
        else
          matchs.reverse!
          tag = ->t{ "</#{t}>" }
        end
        matchs.compact.map { |word| tag[word] }.join
      end
    end

    def test(*args)
      args = (0..109).to_a if args.empty?
      args.each_with_index do |color, index|
        print parse("<#{color}> #{color} </#{color}>") + "\t"
        puts if (index + 1) % 10 == 0
      end
    end

    def colorize(text, color)
      parse("<#{color}>#{escape(text)}</#{color}>")
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
      @result << @tag_stack.map{|i| to_esc_seq(i)}.join unless @tag_stack.empty?
    end

    def to_esc_seq(name)
      if (HighLine.const_defined?(name.upcase) rescue false)
        HighLine.const_get(name.upcase)
      else
        case name
        when /^([fb])(\d+)$/
          fb = $1 == 'f' ? 38 : 48
          color = $2.size == 3 ? 16 + $2.to_i(6) : 232 + $2.to_i
          "\e[#{fb};5;#{color}m"
        when /^[^0-9]?(\d+)$/
          "\e[#{$1}m"
        end
      end
    end
  end
end

class String
  def termcolor
    TermColor.parse(self)
  end
end
