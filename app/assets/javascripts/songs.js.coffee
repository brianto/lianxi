# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  # Only apply for song#show
  return unless $("#songs.show").length

  # Initialize tooltips
  $(".tooltip-hint").tooltip();
