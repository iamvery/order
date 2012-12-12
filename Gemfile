source :rubygems

gemspec

platforms :jruby do
  group :test do
    gem 'activerecord-jdbcsqlite3-adapter', '~> 1.2.2'
  end
end

platforms :ruby do
  group :test do
    gem 'sqlite3'
  end
end

group :test do
  gem 'simplecov', :require => false
  gem 'rake', '~> 10.0'
  gem 'rspec', '~> 2.12'
end
