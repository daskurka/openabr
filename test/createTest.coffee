#controller = require '../server/controllers/dynamicController'
Model = require '../server/models/subjectModel'

describe 'dynamic controller', () ->
  describe '#create()', () ->
    it 'should throw error if incorrect fields in raw data', () ->
      #raw =
        #name: 'bla'

      #controller.create raw, Model, 'subject', (err) ->
        #if err? then done() else done('No error!')