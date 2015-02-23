PageView = require './../base.coffee'
templates = require '../../templates'

FormView = require '../../views/upload/confirm-form-view.coffee'
ReviewView = require '../../views/upload/confirm-review-view.coffee'

Select2Config = require '../../utils/select2-configurations.coffee'
select2 = require 'select2'

async = require 'async'

module.exports = PageView.extend

  pageTitle: 'Review and Commit'
  template: templates.pages.upload.reviewAndCommit

  session:
    formView: 'any'

  events:
    'click [data-hook~=cancel]': 'cancel'
    'click [data-hook~=next]': 'next'
    'click #modalQuit': 'quit'

  render: () ->
    @.renderWithTemplate()

    #tag selector
    input = @.queryByHook('tag-selector')
    config = Select2Config.buildAllAbrTag('Select or create tags...',yes)
    $(input).select2(config)

    return @

  cancel: () -> $('#leaveModal').modal('show')
  quit: () -> app.navigate('')
  next: () ->

    #check form first
    if not @.formView.checkFormValid() then return

    #get form and tag data
    formData = @.formView.getFormData()
    tagsData = $(@.queryByHook('tag-selector')).select2('val')

    #save subject if updated
    do @.model.subject.save

    #commiting to database top down,
    @.model.groups.each (group) ->

      #form data and tags
      if not group.fields? then group.fields = {}
      group.fields[key] = formData[key] for key of formData
      group.tags = tagsData

      group.quicksave
        success: (groupModel) ->
          groupId = groupModel.id
          groupDate = groupModel.date
          groupModel.sets.each (set) ->
            set.groupId = groupId
            set.date = groupDate

            #form data and tags
            if not set.fields? then set.fields = {}
            set.fields[key] = formData[key] for key of formData
            set.tags = tagsData

            set.quicksave
              success: (setModel) ->
                setId = setModel.id
                setModel.readings.each (reading) ->
                  reading.setId = setId
                  reading.date = groupDate

                  #form data and tags
                  if not reading.fields? then reading.fields = {}
                  reading.fields[key] = formData[key] for key of formData
                  reading.tags = tagsData

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

  subviews:
    form:
      hook: 'form-area'
      waitFor: 'model'
      prepareView: (el) ->
        @.formView = new FormView(el: el, model: @.model)
        return @.formView
    review:
      hook: 'review-area'
      waitFor: 'model'
      prepareView: (el) ->
        return new ReviewView(el: el, model: @.model)

