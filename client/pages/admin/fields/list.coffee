State = require 'ampersand-state'
PageView = require '../../base.coffee'
templates = require '../../../templates'

DataFieldsCollection = require '../../../collections/core/data-fields.coffee'
FixedDataFieldsCollection = require '../../../collections/core/fixed-data-fields.coffee'

FixedFieldView = require '../../../views/items/fixed-data-field.coffee'
FieldView = require '../../../views/items/data-field.coffee'

ViewModel = State.extend
  props:
    col: 'string'
  derived:
    collectionName:
      deps: ['col']
      fn: () ->
        switch @.col
          when 'subject' then return 'Subject'
          when 'experiment' then return 'Experiment'
          when 'abr-group' then return 'ABR Group'
          when 'abr-set' then return 'ABR Set'
          when 'abr-reading' then return 'ABR Reading'

module.exports = PageView.extend

  pageTitle: 'Fields Administration'
  template: templates.pages.admin.fields.list

  initialize: (spec) ->
    @.collectionName = spec.col
    @.model = new ViewModel(col: spec.col)
    @.fields = new DataFieldsCollection()
    @.fixedFields = new FixedDataFieldsCollection()
    @.fixedFields.addFixedFields(@.collectionName)

  bindings:
    'model.collectionName': '[data-hook=collection-name]'
    'model.col':
      hook: 'fields-nav'
      type: (el, value, previousValue) ->
        $(el).find('li').removeClass('active')
        $(el).find("li.#{value}-li").addClass('active')

  events:
    'click [data-hook~=add-user-field]': 'handleAddUserFieldClick'

  render: () ->
    #render everything
    @.renderWithTemplate(@)

    @.renderCollection(@.fixedFields, FixedFieldView, @.queryByHook('fixed-fields-table'))

    @.fields.loadFields @.collectionName, () =>
      @.renderCollection(@.fields, FieldView, @.queryByHook('fields-table'))

    return @

  handleAddUserFieldClick: () ->
    app.navigate("/admin/fields/#{@.collectionName}/create")