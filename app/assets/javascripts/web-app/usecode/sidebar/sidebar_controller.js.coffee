class SidebarController extends ApplicationController
  layout: "sidebar/sidebar"
  secondaryView: true
  className: "iugu-main-sidebar"

  events:
    'click [data-action=contacts]' : 'openContact'
    'click [data-action=dashboard]' : 'openDashboard'

  initialize: ->
    super

  openContact: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['contact#index'], trigger: true

  openDashboard: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['dashboard#index'], trigger: true

@SidebarController = SidebarController
