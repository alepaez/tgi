class ProductController extends ApplicationController

@ProductController = ProductController

class ProductIndex extends ProductController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = 'Produtos'

    @configureProducts()

    @search = new IuguUI.Search
      collection: @collection
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-search'

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        description: 'Descrição'
        price_cents: 'Preço'
      parent: @
      identifier: 'product-table'

    buttons =
      new_product:
        text: 'Novo Produto'
        class: 'ui-add-button'

    if @options.callbackView
      buttons_back =
        back:
          text: 'voltar'
          class: 'ui-back-button'

      _.extend buttons_back, buttons
      buttons = buttons_back
    
    @button_toolbar = new IuguUI.Toolbar
      buttons: buttons
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-button-toolbar'

    @on( 'product-table:record:click', @openProduct, @ )
    @on( 'product-button-toolbar:new_product:click', @newProduct, @ )
    @on( 'product-button-toolbar:back:click', @back, @ )

    @enableLoader()
    @collection.fetch reset: true
  
  context: ->
    products: @collection
    
  newProduct: ->
    Backbone.history.navigate app.routes['product#new'], { trigger: true }

  openProduct: (context) ->
    if @options.callbackView
      app.rootWindow.popView context.model
    else
      Backbone.history.navigate app.routes['product#show'].replace(':id', context.model.get('id')), { trigger: true }

  back: ->
    app.rootWindow.popView()
    
  render: ->
    super

    @delegateChild
      '.dataset-search': @search
      '.table-dataset': @table
      '.buttons'      : @button_toolbar

  configureProducts: ->
    @collection = new app.Products
    @collection.on 'reset', @load

@ProductIndex = ProductIndex

class ProductEdit extends ProductController
  layout: 'default-horizontal-split-view'

  initialize: ->
    super

    that = @

    @model = new window.app.Product

    @formView = new IuguUI.View
      model: @model
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-edit-view'
      layout: 'product/edit'
      secondaryView: true

    @toolbar = new IuguUI.Toolbar
      buttons:
        back:
          text: "Voltar"
        save_product:
          text: "Salvar"
          class: 'default'
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-edit-button-toolbar'

    @on( 'product-edit-button-toolbar:back:click', @redirectBack, @ )
    @on( 'product-edit-button-toolbar:save_product:click', @save, @ )

    @enableLoader()
    @render()

    if @options.id
      @title = "Editar Contato"
      @configureProduct()
      @model.fetch(complete: -> that.load())
    else
      @title = "Novo Contato"
      @load
  
  render: ->
    super

    @formView.title = @title

    @delegateChild
      '.split-view-top'    : @formView
      '.split-view-bottom' : @toolbar

  configureProduct: ->
    @model.set 'id', @options.id
    @model.on 'fetch', @enableLoader, @
  
  save: ->
    window.app.model = @model
    @model.save null,
      context: @

@ProductEdit = ProductEdit

class ProductShow extends ProductController
  layout: 'default-horizontal-split-view'

  initialize: ->
    super
    that = @

    @title = "Produto #{@options.id.substr(-8)}"

    @configureProduct()

    @productView = new IuguUI.View
      context: ->
        product: that.product
      baseURL: @options.baseURL
      title: @title
      parent: @
      identifier: 'product-show-view'
      layout: 'product/show'
      secondaryView: true

    @toolbar = new IuguUI.Toolbar
      buttons:
        back:
          text: 'voltar'
        edit:
          text: 'editar'
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-show-button-toolbar'

    @on( 'product-show-button-toolbar:back:click', @redirectBack, @ )
    @on( 'product-show-button-toolbar:edit:click', @editProduct, @ )

    @product.fetch(complete: -> that.load())
      
  configureProduct: ->
    @product = new window.app.Product { id: @options.id }
    @product.on 'fetch', @enableLoader, @

  editProduct: ->
    Backbone.history.navigate app.routes['product#edit'].replace(':id', @options.id), { trigger: true }

  render: ->
    super

    @delegateChild
      '.split-view-top' : @productView
      '.split-view-bottom' : @toolbar

@ProductShow = ProductShow
