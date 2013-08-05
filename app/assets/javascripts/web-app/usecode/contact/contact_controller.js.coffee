class ContactController extends ApplicationController

@ContactController = ContactController

class ContactIndex extends ContactController
  layout: 'default-table-view'

  initialize: ->
    super

    @title = _t "default_actions.webhooks"

    @configureContacts()

    @table = new IuguUI.Table
      collection: @collection
      baseURL: @options.baseURL
      fields:
        id: 'ID'
        url: 'URL'
      parent: @
      identifier: 'contact-table'
    
    @button_toolbar = new IuguUI.Toolbar
      buttons:
        new_contact:
          class: 'ui-add-button'
      baseURL: @options.baseURL
      parent: @
      identifier: 'contact-button-toolbar'

    @on( 'contact-button-toolbar:new_contact:click', @newContact, @ )

    @enableLoader()
    @collection.fetch reset: true
  
  context: ->
    contacts: @collection
    
  newContact: ->
    Backbone.history.navigate app.routes['contact#new'], { trigger: true }
    
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
    debug "coco"
    super

    @formView.title = @title

    @delegateChild
      '.split-view-top'    : @formView
      '.split-view-bottom' : @toolbar

  configure_contact: ->
    @model.set 'id', @options.id
    @model.on 'fetch', @enableLoader, @
  
  save: ->
    @model.save null,
      context: @

@ContactEdit = ContactEdit
