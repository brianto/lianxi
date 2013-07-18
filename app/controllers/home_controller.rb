class HomeController < ApplicationController
  def index
    @drills = Drill.find(:all)
    @passages = Passage.find(:all)
    @songs = Song.find(:all)
  end

  def about
  end
end
