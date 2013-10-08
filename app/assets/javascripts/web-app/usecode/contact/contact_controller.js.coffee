class ContactController extends ApplicationController

@ContactController = ContactController

class ContactIndex extends ContactController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = 'Contatos'

    @configureContacts()

    @search = new IuguUI.Search
      collection: @collection
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-search'

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        name: 'Nome'
        email: 'Email'
      parent: @
      identifier: 'contact-table'

    buttons =
      new_contact:
        text: 'Novo'
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
      identifier: 'contact-button-toolbar'

    @paginator = new IuguUI.Paginator
      enableAdicionalButtons: false
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-paginator'

    IuguUI.Helpers.bindPaginatorToCollection @collection, @paginator, @

    @on( 'contact-table:record:click', @openContact, @)
    @on( 'contact-button-toolbar:new_contact:click', @newContact, @ )
    @on( 'contact-button-toolbar:back:click', @back, @ )

    @enableLoader()
    @collection.fetch reset: true
  
  context: ->
    contacts: @collection
    
  newContact: ->
    Backbone.history.navigate app.routes['contact#new'], { trigger: true }

  openContact: ( context ) ->
    if @options.callbackView
      app.rootWindow.popView context.model
    else
      Backbone.history.navigate app.routes['contact#show'].replace(':id', context.model.get('id')), { trigger: true }

  back: ->
    app.rootWindow.popView()

  render: ->
    super

    @delegateChild
      '.dataset-search': @search
      '.table-dataset': @table
      '.buttons'      : @button_toolbar
      '.paginator'    : @paginator

  configureContacts: ->
    @collection = new app.Contacts
    @collection.on 'reset', @load
    @collection.paginator_ui.perPage = 20

@ContactIndex = ContactIndex

class ContactEdit extends ContactController
  layout: 'default-horizontal-split-view'
  
  events:
    'click .add-phone': 'addPhone'
    'click .remove-phone': 'removePhone'
    'click .add-address': 'addAddress'
    'click .remove-address': 'removeAddress'

  initialize: ->
    super

    that = @
    @model = new window.app.Contact

    @formView = new IuguUI.View
      model: @model
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-edit-view'
      layout: 'contact/edit'
      secondaryView: true

    @toolbar = new IuguUI.Toolbar
      buttons:
        back:
          text: "Voltar"
        save_contact:
          text: "Salvar"
          class: 'default'
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-edit-button-toolbar'

    @on( 'contact-edit-button-toolbar:back:click', @redirectBack, @ )
    @on( 'contact-edit-button-toolbar:save_contact:click', @save, @ )

    if @options.id
      @title = "Editar Contato"
      @configureContact()
      @model.fetch(complete: -> that.load())
    else
      @title = "Novo Contato"
      @load()
  
  render: ->
    super

    @formView.title = @title

    @delegateChild
      '.split-view-top'    : @formView
      '.split-view-bottom' : @toolbar

  configureContact: ->
    @model.set 'id', @options.id
    @model.on 'fetch', @enableLoader, @
  
  save: ->
    @model.save null,
      context: @

  addPhone: (evt) ->
    evt.preventDefault()
    @model.addToPhones()

  removePhone: (evt) ->
    evt.preventDefault()
    cid = $(evt.target).attr 'cid'
    phone = @model.get('phones').getByCid cid
    @model.removeFromPhones phone

  addAddress: (evt) ->
    evt.preventDefault()
    @model.addToAddresses()

  removeAddress: (evt) ->
    evt.preventDefault()
    cid = $(evt.target).attr 'cid'
    address = @model.get('addresses').getByCid cid
    @model.removeFromAddresses address


@ContactEdit = ContactEdit

class ContactShow extends ContactController
  layout: 'default-horizontal-split-view'

  initialize: ->
    super
    that = @

    @title = "Contato #{@options.id.substr(-8)}"

    @configureContact()

    @contactView = new IuguUI.View
      context: ->
        contact: that.contact
      baseURL: @options.baseURL
      title: @title
      parent: @
      identifier: 'contact-show-view'
      layout: 'contact/show'
      secondaryView: true

    @toolbar = new IuguUI.Toolbar
      buttons:
        back:
          text: 'voltar'
        edit:
          text: 'editar'
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-show-button-toolbar'

    @on( 'contact-show-button-toolbar:back:click', @redirectBack, @ )
    @on( 'contact-show-button-toolbar:edit:click', @editContact, @ )

    @contact.fetch(complete: -> that.contactLoaded())
      
  configureContact: ->
    @contact = new window.app.Contact { id: @options.id }
    @contact.on 'fetch', @enableLoader, @

  editContact: ->
    Backbone.history.navigate app.routes['contact#edit'].replace(':id', @options.id), { trigger: true }

  contactLoaded: ->
    @contact.getStrategicInfo(@load)
    window.app.contact_deb = @contact

  render: ->
    super

    @delegateChild
      '.split-view-top' : @contactView
      '.split-view-bottom' : @toolbar

@ContactShow = ContactShow
