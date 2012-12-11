require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
    add_filter "/vendor/"
end

$:.unshift('./lib')
require 'bundler'
require 'bundler/setup'
require 'vmc'
require 'cli'

require 'spec'
require 'webmock/rspec'

def spec_asset(filename)
  File.expand_path(File.join(File.dirname(__FILE__), "assets", filename))
end
