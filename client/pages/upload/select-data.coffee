PageView = require './../base.coffee'
templates = require '../../templates'
ViewSwitcher = require 'ampersand-view-switcher'

SigGenView = require '../../views/upload/sig-gen.coffee'
UnknownFileView = require '../../views/upload/unknown-file.coffee'

module.exports = PageView.extend

  pageTitle: 'About'
  template: templates.pages.upload.selectData

  events:
    'change [data-hook~=upload-file]': 'loadFile'

  props:
    lastFile: 'any'

  fileReader: null
  parseSwitcher: null

  initialize: () ->
    if window.File and window.FileReader and window.FileList and window.Blob
      console.log 'We have full HTML5 File API support.'

      @.fileReader = new FileReader()

    else
      alert('The File APIs are not fully supported in the browser. Please consider upgrading.')
      app.navigate('')

  render: () ->
    @.renderWithTemplate()
    parseAreaEl = @.queryByHook('parse-area')
    @.parseSwitcher = new ViewSwitcher(parseAreaEl)
    return @

  loadFile: (event) ->
    @.lastFile = event.target.files[0]
    ext = /(?:\.([^.]+))?$/.exec(@.lastFile.name)[1]

    console.log ext

    if not ext? then ext = null

    switch ext
      when 'arf'
        @.fileReader.onload = (e) => @.parseSwitcher.set(new SigGenView(array: e.target.result, filename: @.lastFile.name))
        @.fileReader.readAsArrayBuffer @.lastFile
      else
        @.parseSwitcher.set(new UnknownFileView(filename: @.lastFile.name))