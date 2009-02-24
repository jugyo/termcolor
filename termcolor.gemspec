# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'termcolor'
  s.version = '0.2.1'
  s.summary = "Termcolor is a library for ANSII color formatting like HTML for output in terminal."
  s.description = "Termcolor is a library for ANSII color formatting like HTML for output in terminal."
  s.files = %w( lib/termcolor.rb
                spec/spec_helper.rb spec/termcolor_spec.rb
                
                README.rdoc
                History.txt
                Rakefile )
  s.add_dependency("highline", ">= 1.5.0")
  s.author = 'jugyo'
  s.email = 'jugyo.org@gmail.com'
  s.homepage = 'http://github.com/jugyo/termcolor'
  s.rubyforge_project = 'termcolor'
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc", "--exclude", "spec"]
  s.extra_rdoc_files = ["README.rdoc", "History.txt"]
end
