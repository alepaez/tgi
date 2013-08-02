class window.app.Contact extends window.app.BaseResource
  identifier: "contact"
  urlRoot: api_base + 'contacts'

  collection: window.app.Contacts

  initialize: ->
    super

class window.app.Contacts extends window.app.BaseResources
  model: window.app.Contact

  paginator_core:
    url: api_base + 'contacts?&'
    dataType: 'json'
