View = require 'ampersand-view'
ViewSwitcher = require 'ampersand-view-switcher'
async = require 'async'

templates = require '../../templates'

SubjectCollection = require '../../collections/core/subjects.coffee'
SubjectModel = require '../../models/core/subject.coffee'
CreateSubjectView = require '../../views/subject/create-subject.coffee'
SelectSubjectView = require '../../views/subject/select-subject.coffee'

module.exports = View.extend

  template: templates.views.subjects.subjectSelector

  props:
    evidence: 'array'

  children:
    subject: SubjectModel

  initialize: (spec) ->
    @.evidence = spec.evidence

  render: () ->
    @.renderWithTemplate()
    @.viewEl = @.queryByHook('area')
    @.switcher = new ViewSwitcher(@.viewEl)

    @.evidence = @.evidence.filter((item) -> item isnt '')

    if @.evidence? and @.evidence.length > 0
      async.detect(@.evidence, (item, cb) ->
        sc = new SubjectCollection()
        sc.on 'page:loaded', () ->
          if sc.length > 0 then cb(yes) else cb(no)
        sc.query item
      , (result) =>
          if result?
            s = new SubjectCollection()
            s.on 'page:loaded',() =>
              @.subject = s.models[0]
              @.showSelectView()
            s.query result
          else
            @.showSelectView()
      )
    else
      @.showSelectView()

  showSelectView: () ->
    selectView = if @.subject? then new SelectSubjectView(model: @.subject) else new SelectSubjectView()
    selectView.on 'create:subject', () => @.showCreateView()
    selectView.on 'subject:selected', (subject) =>
      @.subject = subject
      @.parent.trigger 'subject-selector:subject:selected', @.subject
    @.switcher.set selectView

  showCreateView: () ->
    createView = new CreateSubjectView()
    createView.on 'subject:created', (subject) =>
      @.subject = subject
      @.parent.trigger 'subject-selector:subject:selected', @.subject
      @.showSelectView()
    createView.on 'cancelled', () => @.showSelectView()
    @.switcher.set createView