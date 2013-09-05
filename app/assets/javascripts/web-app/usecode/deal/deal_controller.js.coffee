class DealController extends ApplicationController

@DealController = DealController

class DealIndex extends DealController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = 'Negocios'

    @configureDeals()

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        id: "ID"
      parent: @
      identifier: 'deal-table'

    @button_toolbar = new IuguUI.Toolbar
      buttons:
        new_deal:
          text: "Novo Negócio"
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-button-toolbar'

    #@on( 'deal-table:record:click', @openProduct, @ )
    #@on( 'deal-button-toolbar:new_product:click', @newProduct, @ )

    @enableLoader()
    @collection.fetch reset: true

  render: ->
    super

    @delegateChild
      '.table-dataset': @table
      '.buttons'      : @button_toolbar

  configureDeals: ->
    @collection = new app.Deals
    @collection.on 'reset', @load

@DealIndex = DealIndex


