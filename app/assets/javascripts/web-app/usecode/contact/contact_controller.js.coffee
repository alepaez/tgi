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

    #@on( 'contact-table:record:click', @openContact, @ )
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
  layout: 'contact/edit'

  initialize: ->
    super
    @load()
    @
  
  render: ->
    super
    @

@ContactEdit = ContactEdit
