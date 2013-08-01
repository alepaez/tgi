class ContactController extends ApplicationController

@ContactController = ContactController

class ContactIndex extends ContactController
  layout: 'contact/index'

  initialize: ->
    super
    @load()
    @
  
  render: ->
    super
    @

@ContactIndex = ContactIndex
