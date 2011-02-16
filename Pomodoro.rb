# Pomodoro.rb
# Tomaten
#
#Copyright (c) 2010 ReBorg - Renzo Borgatti, Niko Schwarz

#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#require 'time'
require 'date'

DB_PATH = File.expand_path("~/Library/Application Support/Tomaten/db.txt")
begin
	Dir.mkdir( File.expand_path("~/Library/Application Support/Tomaten/"))
rescue Errno::EEXIST
end
File.open(DB_PATH, "a") {|f| }

class Pomodoro
  attr_accessor :text, :timestamp
  SPLIT_PATTERN = "! !"
  
  def self.initialize
	puts WAAAA
	raise
	
#Errno::EEXIST: File exists - /tmp

    end
  
  def initialize(params = {})
    @text = params[:text]
    @timestamp = params[:timestamp]
  end
  
  def timestamp
    @timestamp ||= DateTime.now.to_s
  end
  
  def text
	@text ||= ""
  end
  
  def tags
    @text.scan(/@\w+/)
  end
  
  def save()
	self.class.openDbFile { |f| f.print( timestamp.to_s + SPLIT_PATTERN + text + "\n")}
  end
  
  def self.openDbFile( &proc)
	File.open(DB_PATH, "a" ) { |f|
		proc.call(f)
	}
  end
  
  def self.allPomodoros
	pomodoros = IO.readlines(DB_PATH)
	pomodoros = pomodoros.collect { |line|
		timestamp, text = line.split(SPLIT_PATTERN)
		timestamp = DateTime.parse(timestamp)
		Pomodoro.new(:text => text, :timestamp => timestamp) 
	}
	pomodoros
  end
  
  def self.todaysPomodoros
	allPomodoros.select { |p| p.timestamp.to_date == Date.today }
  end
  
  def self.yesterdaysPomodoros
		allPomodoros.select { |p| p.timestamp.to_date == (Date.today-1).to_date }
  end
  
  def self.showDatabase
		system("open '#{DB_PATH}'")
  end
end

