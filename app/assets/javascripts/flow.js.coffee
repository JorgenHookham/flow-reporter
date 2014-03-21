# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$.ajax
  url: 'dropbox/list-flow-responses.json'
  contentType: 'application/json'
  success: (responses) ->
    responses.forEach (response) ->
      parent = $ '.js-nodes'
      element = $ document.createElement('div')
      element.attr 'class', 'node'
      element.attr 'data-skill', response.skill.numericResponse || -1
      element.attr 'data-challenge', response.challenge.numericResponse || -1
      parent.append element