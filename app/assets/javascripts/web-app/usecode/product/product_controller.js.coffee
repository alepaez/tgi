class ProductController extends ApplicationController

@ProductController = ProductController

class ProductIndex extends ProductController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = 'Produtos'

    @configureProducts()

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        description: 'Descrição'
        price_cents: 'Preço'
        status: 'Estado'
      parent: @
      identifier: 'product-table'
    
    @button_toolbar = new IuguUI.Toolbar
      buttons:
        new_product:
          text: 'Novo Produto'
          class: 'ui-add-button'
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-button-toolbar'

    @on( 'product-button-toolbar:new_product:click', @newProduct, @ )

    @enableLoader()
    @collection.fetch reset: true
  
  context: ->
    products: @collection
    
  newProduct: ->
    Backbone.history.navigate app.routes['product#new'], { trigger: true }
    
  render: ->
    super

    @delegateChild
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
        save_product:
          text: "Salvar"
          class: 'default'
      baseURL: @options.baseURL
      parent: @
      identifier: 'product-edit-button-toolbar'

    @on( 'product-edit-button-toolbar:save_product:click', @save, @ )

    @enableLoader()
    @render()

    if @options.id
      @title = "Editar Contato"
      @configure_product
    else
      @title = "Novo Contato"

    @load
  
  render: ->
    super

    @formView.title = @title

    @delegateChild
      '.split-view-top'    : @formView
      '.split-view-bottom' : @toolbar

  configure_product: ->
    @model.set 'id', @options.id
    @model.on 'fetch', @enableLoader, @
  
  save: ->
    window.app.model = @model
    @model.save null,
      context: @

@ProductEdit = ProductEdit
