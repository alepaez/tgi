class window.app.Phone extends window.app.BaseResource
  identifier: "phone"

class window.app.Phones extends window.app.BaseResources
  model: window.app.Phone

class window.app.Address extends window.app.BaseResource
  identifier: "address"

class window.app.Addresses extends window.app.BaseResources
  model: window.app.Address

class window.app.Contact extends window.app.BaseResource
  identifier: "contact"
  urlRoot: api_base + 'contacts'

  collection: window.app.Contacts

  relations: [
    {
      type: Backbone.Many
      key: "phones"
      relatedModel: window.app.Phone
      collectionType: window.app.Phones
    },
    {
      type: Backbone.Many
      key: "addresses"
      relatedModel: window.app.Address
      collectionType: window.app.Addresses
    }
  ]

  initialize: ->
    super

class window.app.Contacts extends window.app.BaseResources
  model: window.app.Contact

  paginator_core:
    url: api_base + 'contacts?&'
    dataType: 'json'
