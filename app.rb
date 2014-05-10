# coding: utf-8

require 'bundler'
Bundler.require


class App < Thor

  desc 'convert', 'convert ClojureBiyori into epub.'
  def convert
  end

  desc 'fetch', 'fetch ClojureBiyori source files.'
  def fetch
    if FileTest.exist? "#{__dir__}/source"
      puts "Update source files."
      `cd #{__dir__}/source; git pull`
    else
      puts "Source files doesn't exist."
      `git clone git@github.com:esehara/ClojureBiyori.git source`
    end
  end

end

App.start ARGV
