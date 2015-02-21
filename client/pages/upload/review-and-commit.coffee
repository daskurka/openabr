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

    #save subject if updated
    @.model.subject.save
      success: () ->
        console.log 'subject save complete'
      error: () ->
        console.log 'error saving subject'

    #commiting to database top down,
    @.model.groups.each (group) ->

      group.quicksave
        success: (groupModel) ->
          groupId = groupModel.id
          groupDate = groupModel.date
          groupModel.sets.each (set) ->
            set.groupId = groupId
            set.date = groupDate
            set.quicksave
              success: (setModel) ->
                setId = setModel.id
                setModel.readings.each (reading) ->
                  reading.setId = setId
                  reading.date = groupDate
                  reading.save null,
                    error: () ->
                      console.log 'error saving a reading'
                    success: () ->
                      console.log 'save complete...'
                      app.navigate('subjects')
              error: () ->
                console.log 'error saving a set'
        error: () ->
          console.log 'there was an error saving the group!'
