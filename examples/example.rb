# -*- coding: utf-8 -*-
require 'rubygems'
require 'termcolor'

puts TermColor.parse <<EOS

    <on_blue><white><bold>TermColor Example</bold></white></on_blue>

    <on_green><white>Termcolor</white></on_green> is a library for <red><bold>ANSII</bold></red> <blue>c</blue><yellow>o</yellow><green>l</green>o<red>r</red> formatting like <on_magenta>HTML</on_magenta>
    for output in terminal.

EOS

["REVERSE", "ON_RED", "DARK", "MAGENTA", "ColorScheme", "RESET", "RED", "ON_BLUE", "BLINK", "ON_BLACK", "BOLD", "BLUE", "ON_WHITE", "QuestionError", "CLEAR", "BLACK", "ON_YELLOW", "SampleColorScheme", "UNDERSCORE", "WHITE", "SystemExtensions", "ERASE_CHAR", "YELLOW", "ON_CYAN", "CONCEALED", "ON_GREEN", "CHARACTER_MODE", "UNDERLINE", "CYAN", "Question", "Menu", "VERSION", "ERASE_LINE", "GREEN", "ON_MAGENTA"]
