PageView = require './../base.coffee'
templates = require '../../templates'

async = require 'async'

module.exports = PageView.extend

  pageTitle: 'Review and Commit'
  template: templates.pages.upload.reviewAndCommit

  events:
    'click [data-hook~=cancel]': 'cancel'
    'click [data-hook~=next]': 'next'
    'click #modalQuit': 'quit'

  cancel: () -> $('#leaveModal').modal('show')
  quit: () -> app.navigate('')
  next: () ->

    #commiting to database top down,
    @.model.groups.each (group) ->

      group.quicksave
        success: (groupModel) ->
          groupId = groupModel.id
          groupModel.sets.each (set) ->
            set.groupId = groupId
            set.quicksave
              success: (setModel) ->
                setId = setModel.id
                setModel.readings.each (reading) ->
                  reading.setId = setId
                  reading.save null,
                    error: () ->
                      console.log 'error saving a reading'
              error: () ->
                console.log 'error saving a set'
        error: () ->
          console.log 'there was an error saving the group!'