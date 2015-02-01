Base = require '../base.coffee'

module.exports = Base.extend

  typeAttribute: 'subjectModel'
  urlRoot: '/api/subjects'

  props:
    experiments: 'array' #[objectId]
    creator: 'any' #objectId
    created: 'date'
    reference: 'string'
    strain: 'string'
    species: 'string'
    dob: 'date'
    dod: 'date'
    fields: 'object'

  derived:
    age:
      deps: ['dob','dod']
      fn: () ->
        current = if @.dod? then @.dod else Date.now()
        diff = current - @.dob.getTime()
        weeks = Math.ceil(diff / 604800000)
        return weeks
    isAlive:
      deps: ['dod']
      fn: () ->
        return @.dod?
    textDob:
      deps: ['dob','age','isAlive']
      fn: () ->
        datePart = @.dob.toISOString().split('T')[0]
        return if @.isAlive then "#{datePart} (#{@.age} weeks)" else "#{datePart}"
    textDod:
      deps: ['dod','age','isAlive']
      fn: () ->
        datePart = @.dob.toISOString().split('T')[0]
        return if @.isAlive then '—' else "#{datePart} (#{@.age} weeks)"

