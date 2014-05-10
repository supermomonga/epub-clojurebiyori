# coding: utf-8

require 'bundler'
Bundler.require


class App < Thor

  desc 'convert', 'convert ClojureBiyori into epub.'
  def convert
  end

  desc 'fetch', 'fetch ClojureBiyori source files.'
  def fetch
    source_dir = "#{__dir__}/source"
    if FileTest.exist? source_dir
      puts "Update source files."
      `cd #{source_dir}; git pull`
    else
      puts "Source files doesn't exist."
      `git clone git@github.com:esehara/ClojureBiyori.git #{source_dir}`
    end
  end

end

App.start ARGV
