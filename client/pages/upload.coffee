PageView = require './base.coffee'
templates = require '../templates'
ViewSwitcher = require 'ampersand-view-switcher'

SigGenView = require '../views/upload/sig-gen.coffee'
UnknownFileView = require '../views/upload/unknown-file.coffee'

module.exports = PageView.extend

  pageTitle: 'About'
  template: templates.pages.upload

  events:
    'change [data-hook~=upload-file]': 'loadFile'

  fileReader: null
  parseSwitcher: null

  initialize: () ->
    if window.File and window.FileReader and window.FileList and window.Blob
      console.log 'We have full HTML5 File API support.'

      @.fileReader = new FileReader()
      @.fileReader.onload = (e) => @.readFile(e.target.result)

    else
      alert('The File APIs are not fully supported in the browser. Please consider upgrading.')
      app.navigate('')

  render: () ->
    @.renderWithTemplate()
    parseAreaEl = @.queryByHook('parse-area')
    @.parseSwitcher = new ViewSwitcher(parseAreaEl)
    return @


  loadFile: (event) ->
    file = event.target.files[0]
    @.fileReader.readAsText(file)

  readFile: (text) ->
    #at this point all files are going to be nice UTF-8 encoded and will always
    #use \n for newlines. In the future we will likely have to read and match pure binary.
    lines = text.replace('\r','').split('\n')
    first = lines[0]

    switch first
      when "ABR Group Header  =================================="
        @.parseSwitcher.set(new SigGenView(lines: lines))
      else
        @.parseSwitcher.set(new UnknownFileView(lines: lines))

