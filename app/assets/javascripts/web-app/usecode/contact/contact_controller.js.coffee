class ContactController extends ApplicationController

@ContactController = ContactController

class ContactIndex extends ContactController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = 'Contatos'

    @configureContacts()

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        name: 'Nome'
        email: 'Email'
      parent: @
      identifier: 'contact-table'
    
    @button_toolbar = new IuguUI.Toolbar
      buttons:
        new_contact:
          text: 'Novo Contato'
          class: 'ui-add-button'
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-button-toolbar'

    @on( 'contact-table:record:click', @openContact, @)
    @on( 'contact-button-toolbar:new_contact:click', @newContact, @ )

    @enableLoader()
    @collection.fetch reset: true
  
  context: ->
    contacts: @collection
    
  newContact: ->
    Backbone.history.navigate app.routes['contact#new'], { trigger: true }

  openContact: ( context ) ->
    Backbone.history.navigate app.routes['contact#show'].replace(':id', context.model.get('id')), { trigger: true }

    
  render: ->
    super

    @delegateChild
      '.table-dataset': @table
      '.buttons'      : @button_toolbar

  configureContacts: ->
    @collection = new app.Contacts
    @collection.on 'reset', @load

@ContactIndex = ContactIndex

class ContactEdit extends ContactController
  layout: 'default-horizontal-split-view'
  
  events:
    'click .add-phone': 'addPhone'
    'click .remove-phone': 'removePhone'

  initialize: ->
    super
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
        save_contact:
          text: "Salvar"
          class: 'default'
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-edit-button-toolbar'

    @on( 'contact-edit-button-toolbar:save_contact:click', @save, @ )

    @enableLoader()
    @render()

    if @options.id
      @title = "Editar Contato"
      @configure_contact
    else
      @title = "Novo Contato"

    @load
  
  render: ->
    super

    @formView.title = @title

    @delegateChild
      '.split-view-top'    : @formView
      '.split-view-bottom' : @toolbar

  configure_contact: ->
    @model.set 'id', @options.id
    @model.on 'fetch', @enableLoader, @
  
  save: ->
    window.app.model = @model
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
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-show-button-toolbar'

    @on( 'contact-show-button-toolbar:back:click', @redirectBack, @ )

    @contact.fetch(complete: -> that.load())
      
  configureContact: ->
    @contact = new window.app.Contact { id: @options.id }
    @contact.on 'fetch', @enableLoader, @

  render: ->
    super

    @delegateChild
      '.split-view-top' : @contactView
      '.split-view-bottom' : @toolbar

@ContactShow = ContactShow
