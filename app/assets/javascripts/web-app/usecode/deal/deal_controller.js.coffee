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
        contact: "Contato"
        created_at: "Criado em"
        updated_at: "Alterado em"
      recordPresenter:
        contact: (deal) ->
          deal.get('contact_ref')
        created_at: (deal) ->
          date = new Date(deal.get('created_at').replace(/-/g,"/").replace(/[TZ]/g," "))
          "#{date.getDate()}/#{date.getMonth()}/#{date.getFullYear()} #{date.getHours()}:#{date.getMinutes()}"
        updated_at: (deal) ->
          date = new Date(deal.get('updated_at').replace(/-/g,"/").replace(/[TZ]/g," "))
          "#{date.getDate()}/#{date.getMonth()}/#{date.getFullYear()} #{date.getHours()}:#{date.getMinutes()}"
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
    @on( 'deal-button-toolbar:new_deal:click', @newDeal, @ )

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
    window.app.deals = @collection

  newDeal: ->
    Backbone.history.navigate app.routes['deal#new'], { trigger: true }

@DealIndex = DealIndex

class DealEdit extends DealController
  layout: 'default-horizontal-split-view'

  events:
    'click .select-contact' : 'selectContact'
    'click .add-item': 'addItem'
    'click .remove-item': 'removeItem'
    'click .select-product' : 'selectProduct'

  initialize: ->
    super

    that = @

    @model = new window.app.Deal

    @formView = new IuguUI.View
      model: @model
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-edit-view'
      layout: 'deal/edit'
      secondaryView: true

    @toolbar = new IuguUI.Toolbar
      buttons:
        back:
          text: "Voltar"
        save_deal:
          text: "Salvar"
          class: 'default'
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-edit-button-toolbar'

    @on( 'deal-edit-button-toolbar:back:click', @redirectBack, @ )
    @on( 'deal-edit-button-toolbar:save_deal:click', @save, @ )

    @enableLoader()
    @render()

    if @options.id
      @title = "Editar Negócio"
      @configureDeal()
      @model.fetch(complete: -> that.load())
    else
      @model.set 'contact_ref', 'Clique para escolher um Contato'
      @title = "Novo Negócio"
      @load
  
  render: ->
    super

    @formView.title = @title

    @delegateChild
      '.split-view-top'    : @formView
      '.split-view-bottom' : @toolbar

  configureDeal: ->
    @model.set 'id', @options.id
    @model.on 'fetch', @enableLoader, @

  selectContact: (evt) ->
    evt.preventDefault()

    that = @

    app.rootWindow.pushView new ContactIndex
      identifier: "contact-selection"
      callbackView: true
      secondaryView: true

    @on "contact-selection:pop", (contact) ->
      if contact
        that.model.set 'contact_id', contact.get('id')
        that.model.set 'contact_ref', contact.get('name') || contact.get('email')

      that.delegateEvents()
      that.load()
  
  addItem: (evt) ->
    evt.preventDefault()
    item = @model.addToItems()
    item.set 'product_ref', 'Clique para escolher um produto'

  removeItem: (evt) ->
    evt.preventDefault()
    cid = $(evt.target).attr 'cid'
    item = @model.get('items').getByCid cid
    @model.removeFromItems(item)

  selectProduct: (evt) ->
    evt.preventDefault()

    cid = $(evt.target).attr 'cid'
    window.app.targetEvt = evt

    that = @

    app.rootWindow.pushView new ProductIndex
      identifier: "product-selection"
      callbackView: true
      secondaryView: true

    @on "product-selection:pop", (product) ->
      if product
        item = that.model.get('items').getByCid cid
        item.set 'product_id', product.get('id')
        item.set 'product_ref', product.get('description')

      that.delegateEvents()
      that.load()

  
  save: ->
    @model.save null,
      context: @

@DealEdit = DealEdit
