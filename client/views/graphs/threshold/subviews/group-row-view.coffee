View = require 'ampersand-view'

module.exports = View.extend

  template: "<tr>
              <td data-hook='group'></td>
              <td data-hook='group-actual'></td>
              <td data-hook='type'></td>
              <td data-hook='level'></td>
            </tr>"

  bindings:
    'model.group': '[data-hook~=group]'
    'model.groupActual': '[data-hook~=group-actual]'
    'model.type': '[data-hook~=type]'
    'model.realLevel': '[data-hook~=level]'