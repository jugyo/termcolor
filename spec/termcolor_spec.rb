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

    it 'should raise Error' do
      lambda{ TermColor.parse('aaaaa<red>aaaaa</blue>aaaaa') }.should raise_error(TermColor::ParseError)
      lambda{ TermColor.parse('aaaaa<red>aaaaaaaaaa') }.should_not raise_error(TermColor::ParseError)
    end

    it 'should escape text' do
      text = 'a<foo>&</foo>a'
      TermColor.escape(text).should == "a&lt;foo&gt;&amp;&lt;/foo&gt;a"
    end
  end
end
