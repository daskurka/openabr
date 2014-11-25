State = require 'ampersand-state'

module.exports = State.extend

  props:
    isSimple: ['boolean', yes, no] #is simpler next / last or multiple number <,1,2,3,4,> etc
    maxWidth: ['number', yes, 5] #if not simple then how many numbers between next and last
    collection: 'any' #the collection the view will bind too
