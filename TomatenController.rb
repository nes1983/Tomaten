# TomatenController.rb
# Tomaten
#
# Created by Niko on 04.02.11.
# Copyright 2011 NIKO SCHWARZ. All rights reserved.





class TomatenController

	attr_accessor :doneWindow, :doneText, :mainWindow

	POMODORO_LENGTH = 25 * 60

	def self.automaticallyNotifiesObserversForKey(key)
		return [ "timeLeft", "buttonLabel", "todayCount", "yesterdayCount", "totalCount"].include? key
	end
	
	def applicationShouldTerminateAfterLastWindowClosed(application)
		true
	end
	def initialize
		@status = :waiting
	end

	def awakeFromNib()
	
		NSApp.setDelegate(self)
				
	end
	
	def save(bla)
		NSApp.endSheet doneWindow
		Pomodoro.new(:text => doneText).save
		notifyLabelUpdate
	end
	
	def cancelSave(bla)
		puts "Cancelled"
		NSApp.endSheet doneWindow
	end
	
	
	def todayCount
		Pomodoro.todaysPomodoros.length
	end
	
	def yesterdayCount
		Pomodoro.yesterdaysPomodoros.length
	end
	
	def totalCount
		Pomodoro.allPomodoros.length
	end
	
	
	def didEndSheet(bla, returnCode: aCode, contextInfo: bla3)
		doneWindow.orderOut self
	end
	
	def timeLeft
		if(@status == :waiting)
			"25:00"
		elsif @status == :running
			timeLeftOnTimer
		else 
			raise
		end
	end
	
	def timeLeftOnTimer
		remaining = @taskDone.fireDate.timeIntervalSinceNow
		minutes, seconds = remaining.divmod(60)
		minutes.to_s + ":" + seconds.floor.to_s
	end
	
	def buttonLabel
		if(@status == :waiting)
			"Start"
		elsif @status == :running
			"Void"
		else 
			raise
		end
	end
	
	def notifyLabelUpdate
		self.willChangeValueForKey("buttonLabel")
		self.didChangeValueForKey("buttonLabel") 

		self.willChangeValueForKey("todayCount")
		self.didChangeValueForKey("todayCount")

		self.willChangeValueForKey("yesterdayCount")
		self.didChangeValueForKey("yesterdayCount")
		 
		self.willChangeValueForKey("totalCount")
		self.didChangeValueForKey("totalCount")
	end
	
	def done
		ring
		stopPomodoro
		showSaveDialog
	end
 
	def startPomodoro
		@status = :running
		@taskDone = NSTimer.scheduledTimerWithTimeInterval(
			POMODORO_LENGTH, 
			target:self, 
			selector: :done, 
			userInfo:nil, 
			repeats:false)
		@secondTicked = NSTimer.scheduledTimerWithTimeInterval(
			1, 
			target:self, 
			selector: :notifyTimeUpdate, 
			userInfo:nil, 
			repeats:true)
	end
	
	def stopPomodoro
		@status = :waiting
		@taskDone.invalidate
		@taskDone = nil
		@secondTicked.invalidate
		notifyLabelUpdate
		notifyTimeUpdate
	end
	
	def showAll(bla)
		Pomodoro.showDatabase
	end

	
	def notifyTimeUpdate
		self.willChangeValueForKey("timeLeft")
		self.didChangeValueForKey("timeLeft") 
	end
	
	def showSaveDialog
		NSApp.beginSheet( doneWindow,
            modalForWindow: mainWindow,
            modalDelegate: self,
            didEndSelector: "didEndSheet:returnCode:contextInfo:".to_sym,
            contextInfo: nil)
	end
	
	def startStopClicked(button)
		
		if(@status == :waiting)
			startPomodoro
		elsif @status == :running
			stopPomodoro
		else 
			raise
		end
		notifyLabelUpdate
		notifyTimeUpdate
	end
	
	def ring
		NSSound.soundNamed("bell.aif").play
	end
end
