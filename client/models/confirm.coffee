State = require 'ampersand-state'

#coffeescript cookbook
type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  classToType = {
    '[object Boolean]': 'boolean',
    '[object Number]': 'number',
    '[object String]': 'string',
    '[object Function]': 'function',
    '[object Array]': 'array',
    '[object Date]': 'date',
    '[object RegExp]': 'regexp',
    '[object Object]': 'object'
  }
  return classToType[Object.prototype.toString.call(obj)]

module.exports = State.extend

  typeAttribute: 'confirmState'

  props:
    message: { type: 'string', default: '', required: yes }
    button: {type: 'string', default: 'action', required: yes}
    confirm: { type: 'string', default: 'Are you sure?', required: yes }