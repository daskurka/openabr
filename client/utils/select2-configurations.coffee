module.exports =

  buildExperiment: (placeholder, multiple) ->
    config =
      placeholder: placeholder
      multiple: multiple
      ajax:
        url: '/api/experiments'
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> return {name: {$regex: "#{term}", $options: 'i'} }
        results: (experiments, page) ->
          results = []
          for exp in experiments
            results.push {id: exp.id, text: exp.name}
          return {results: results}
        cache: true
      initSelection: (element, callback) =>
        arr = element[0].value
        userIds = arr.split(',')
        query = {_id: {$in: userIds}}
        $.get @.url, query, (response) ->
          results = []
          for user in response
            results.push {id: user.id, text: user.name}
          callback(results)
    return config

  buildSubject: (placeholder, multiple) ->
    config =
      placeholder: placeholder
      multiple: multiple
      ajax:
        url: '/api/subjects'
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> return {reference: {$regex: "#{term}", $options: 'i'} }
        results: (subjects, page) ->
          results = []
          for subject in subjects
            results.push {id: subject.id, text: subject.reference, value: subject}
          return {results: results}
        cache: true
      initSelection: (element, callback) =>
        id = element[0].value
        query = {_id: id}
        $.get @.url, query, (response) ->
          results = []
          for subject in response
            results.push {id: subject.id, text: subject.reference, value: subject}
          callback(results[0])
    return config

  buildAllAbrTag: (placeholder, multiple) ->
    config =
      placeholder: placeholder
      multiple: multiple
      ajax:
        url: '/api/abr/tags'
        dataType: 'json'
        quietMillis: 250
        results: (tags, page) ->
          results = []
          for tag in tags
            results.push {id: tag, text: tag}
          return {results: results}
        cache: true
      initSelection: (element, callback) =>
        arr = element[0].value
        tags = arr.split(',')
        results = []
        for tag in tags
          results.push {id: tag, text: tag}
        callback(results)
      createSearchChoice: (term) ->
        return {
          id: term
          text: term
        }
    return config