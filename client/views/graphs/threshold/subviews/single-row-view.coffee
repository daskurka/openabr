View = require 'ampersand-view'

module.exports = View.extend

  template: "<tr>
              <td data-hook='type'></td>
              <td data-hook='level'></td>
            </tr>"

  bindings:
    'model.type': '[data-hook~=type]'
    'model.realLevel': '[data-hook~=level]'