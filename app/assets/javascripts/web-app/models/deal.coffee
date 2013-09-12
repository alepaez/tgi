class window.app.DealItem extends window.app.BaseResource
  identifier: "deal_item"

class window.app.DealItems extends window.app.BaseResources
  model: window.app.DealItem

class window.app.Deal extends window.app.BaseResource
  identifier: "deal"
  urlRoot: api_base + 'deals'

  collection: window.app.Deals

  relations: [
    {
      type: Backbone.Many
      key: "items"
      relatedModel: window.app.DealItem
      collectionType: window.app.DealItems
    }
  ]

  initialize: ->
    super

class window.app.Deals extends window.app.BaseResources
  model: window.app.Deal

  paginator_core:
    url: api_base + 'deals?&'
    dataType: 'json'
