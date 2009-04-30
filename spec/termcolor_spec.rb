# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

module TermColor
  describe TermColor do
    before do
    end

    it 'should parse 1' do
      text = TermColor.parse('aaa<red>aaaa<bold>foo</bold>bb<blue>bbbb</blue>bbb</red>ccc<on_yellow>ccccc</on_yellow>ccc')
      puts text
      text.should == "aaa\e[31maaaa\e[1mfoo\e[0m\e[31mbb\e[34mbbbb\e[0m\e[31mbbb\e[0mccc\e[43mccccc\e[0mccc"
    end

    it 'should parse 2' do
      text = TermColor.parse('aa<blue>a<foo>aaa<red>aa</red>aaaa</foo>a</blue>aaa')
      puts text
      text.should == "aa\e[34maaaa\e[31maa\e[0m\e[34maaaa\e[0ma\e[0maaa"
    end

    it 'should parse 3' do
      text = TermColor.parse('aa<blue>aaaaa&lt;aaa&quot;aaa&gt;aaa&amp;aaaaa</blue>aaa')
      puts text
      text.should == "aa\e[34maaaaa<aaa\"aaa>aaa&aaaaa\e[0maaa"
    end

    it 'should parse 3' do
      text = TermColor.parse('aa<30>bbbbbbb<32>cccc<90>ddd</90>c</32>b</30>aaa')
      puts text
      text.should == "aa\e[30mbbbbbbb\e[32mcccc\e[90mddd\e[0m\e[32mc\e[0m\e[30mb\e[0maaa"
    end

    it 'should raise Error' do
      lambda{ TermColor.parse('aaaaa<red>aaaaa</blue>aaaaa') }.should raise_error(REXML::ParseException)
      lambda{ TermColor.parse('aaaaa<red>aaaaaaaaaa') }.should_not raise_error(REXML::ParseException)
    end

    it 'should escape text' do
      TermColor.escape('<>&"\'').should == "&lt;&gt;&amp;&quot;&apos;"
    end

    it 'should unescape text' do
      TermColor.unescape("&lt;&gt;&amp;&quot;&apos;").should == '<>&"\''
    end

    it 'should prepare parse' do
      TermColor.prepare_parse("<10>10</10>").should == '<_10>10</_10>'
      TermColor.prepare_parse("<32>10</32>").should == '<_32>10</_32>'
    end

    it 'should convert to escape sequence' do
      listener = TermColor::MyListener.new
      listener.to_esc_seq('red').should == "\e[31m"
      listener.to_esc_seq('on_red').should == "\e[41m"
      listener.to_esc_seq('foo').should == nil
      listener.to_esc_seq('0').should == "\e[0m"
      listener.to_esc_seq('31').should == "\e[31m"
      listener.to_esc_seq('031').should == "\e[031m"
      listener.to_esc_seq('_0').should == "\e[0m"
      listener.to_esc_seq('_31').should == "\e[31m"
    end
  end
end
