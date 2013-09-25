class SidebarController extends ApplicationController
  layout: "sidebar/sidebar"
  secondaryView: true
  className: "iugu-main-sidebar"

  events:
    'click [data-action=contact]' : 'openContact'
    'click [data-action=product]' : 'openProduct'
    'click [data-action=deal]' : 'openDeal'
    'click [data-action=dashboard]' : 'openDashboard'

  initialize: ->
    super

    Events.on "navigation:go", @displaySelection

  openContact: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['contact#index'], trigger: true

  openProduct: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['product#index'], trigger: true

  openDeal: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['deal#index'], trigger: true

  openDashboard: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['dashboard#index'], trigger: true

  displaySelection: ( action ) ->
    $("*[data-action=" + action + "]").each () ->
      $(@).addClass("selected") unless $(@).hasClass("selected")

    @$(".button").not(".search-filter .button").not("[data-action=" + action + "]").each () ->
      $(@).removeClass("selected")

@SidebarController = SidebarController
