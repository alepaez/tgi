class DealController extends ApplicationController

@DealController = DealController

class DealIndex extends DealController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = 'Negocios'

    @configureDeals()

    @search = new IuguUI.Search
      collection: @collection
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-search'

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        contact: "Contato"
        created_at: "Criado em"
        updated_at: "Alterado em"
        total_localized: "Valor"
        status: "Situação"
      recordPresenter:
        contact: (deal) ->
          deal.get('contact_ref')
        created_at: (deal) ->
          date = new Date(deal.get('created_at').replace(/-/g,"/").replace(/[TZ]/g," "))
          "#{date.getDate()}/#{date.getMonth()}/#{date.getFullYear()} #{date.toLocaleTimeString()}"
        updated_at: (deal) ->
          date = new Date(deal.get('updated_at').replace(/-/g,"/").replace(/[TZ]/g," "))
          "#{date.getDate()}/#{date.getMonth()}/#{date.getFullYear()} #{date.toLocaleTimeString()}"
        status: (deal) ->
          _t "deal_status.#{deal.get('status')}"
      parent: @
      identifier: 'deal-table'

    @button_toolbar = new IuguUI.Toolbar
      buttons:
        new_deal:
          text: "Novo"
          class: 'ui-add-button'
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-button-toolbar'

    @filter_status = new IuguUI.SearchFilter
      collection: @collection
      multiSelection: false
      name: "status"
      filterNames: [ "open", "won", "lost" ]
      fixedFilters: ["open", "won", "lost"]
      translateTerms: true
      translationPrefix: 'deals_status'
      baseURL: @options.baseURL
      parent: @
      identifier: 'deals-status-filter'

    @paginator = new IuguUI.Paginator
      enableAdicionalButtons: false
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-paginator'

    IuguUI.Helpers.bindPaginatorToCollection @collection, @paginator, @

    @on( 'deal-table:record:click', @openDeal, @ )
    @on( 'deal-button-toolbar:new_deal:click', @newDeal, @ )
    @on( 'deals-status-filter:facet:click', @toggleSiderbar, @ )

    @enableLoader()
    @collection.fetch reset: true

  render: ->
    super

    @delegateChild
      '.dataset-search': @search
      '.table-dataset': @table
      '.buttons'      : @button_toolbar
      '.paginator'    : @paginator

    window.Events.trigger "fillSlots",
      "[data-group=deal-filter]": @filter_status.render()

  configureDeals: ->
    @collection = new app.Deals
    @collection.on 'reset', @load
    window.app.deals = @collection

  newDeal: ->
    Backbone.history.navigate app.routes['deal#new'], { trigger: true }

  openDeal: (context) ->
    Backbone.history.navigate app.routes['deal#show'].replace(':id', context.model.get('id')), { trigger: true }

  toggleSidebar: (context) ->
    app.rootWindow.closeSidebar()

  close: ->
    window.Events.trigger "resetSlots", [ "[data-group=deal-filter]" ]
    @collection.removeFiltersEndingWith "_filter"
    @filter_status.close()

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
      @model.set 'contact_ref', 'Escolha um Contato'
      @title = "Novo Negócio"
      @load()
  
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
    item.set 'product_ref', 'Escolha um produto'

  removeItem: (evt) ->
    evt.preventDefault()
    cid = $(evt.target).attr 'cid'
    item = @model.get('items').getByCid cid
    @model.removeFromItems(item)

  selectProduct: (evt) ->
    evt.preventDefault()

    cid = $(evt.target).attr 'cid'

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
      that.off "product-selection:pop"

  
  save: ->
    @model.save null,
      context: @

@DealEdit = DealEdit

class DealShow extends DealController
  layout: 'default-horizontal-split-view'

  initialize: ->
    super
    that = @

    @title = "Negócio #{@options.id.substr(-8)}"

    @configureDeal()

    @dealView = new IuguUI.View
      context: ->
        deal: that.deal
      baseURL: @options.baseURL
      title: @title
      parent: @
      identifier: 'deal-show-view'
      layout: 'deal/show'
      secondaryView: true

    @toolbar = new IuguUI.Toolbar
      buttons:
        back:
          text: 'voltar'
          class: 'ui-back-button'
      baseURL: @options.baseURL
      parent: @
      identifier: 'deal-show-button-toolbar'

    @on( 'deal-show-button-toolbar:back:click', @redirectBack, @ )
    @on( 'deal-show-button-toolbar:edit:click', @editDeal, @ )

    @deal.fetch(complete: -> that.load())
      
  configureDeal: ->
    @deal = new window.app.Deal { id: @options.id }
    @deal.on 'fetch', @enableLoader, @

  editDeal: ->
    Backbone.history.navigate app.routes['deal#edit'].replace(':id', @options.id), { trigger: true }

  render: ->
    super
    window.app.deal = @deal
    @toolbar.options.buttons.edit = { text: 'editar' } if @deal.get('status') == "open"

    @delegateChild
      '.split-view-top' : @dealView
      '.split-view-bottom' : @toolbar

@DealShow = DealShow
