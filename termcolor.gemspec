Gem::Specification.new do |s|
  s.name = 'termcolor'
  s.version = '0.4.6'
  s.summary = "Simple twitter client."
  s.description = "TermColor is a simple twitter client."
  s.files = %w( lib/termcolor/connection.rb lib/termcolor.rb
                spec/termcolor_spec.rb spec/spec_helper.rb
                examples/direct_message.rb examples/favorite.rb examples/follow.rb examples/friends_timeline.rb examples/limit.rb examples/replies.rb examples/search.rb examples/update_status.rb examples/user.rb
                README.rdoc
                History.txt
                Rakefile )
  s.add_dependency("json_pure", ">= 1.1.3")
  s.author = 'jugyo'
  s.email = 'jugyo.org@gmail.com'
  s.homepage = 'http://github.com/jugyo/termcolor'
  s.rubyforge_project = 'termcolor'
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc", "--exclude", "spec"]
  s.extra_rdoc_files = ["README.rdoc", "History.txt"]
end
