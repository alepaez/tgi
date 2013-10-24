class DashboardController extends ApplicationController

@DashboardController = DashboardController

class DashboardIndex extends DashboardController
  layout: 'dashboard/index'
  
  initialize: ->
    super
    that = @

    @dashboard = new app.Dashboard

    @enableLoader()
    @dashboard.getRecentIncome(@load)
    @

  context: ->
    dashboard: @dashboard

  render: ->
    super

DashboardRouter = Backbone.Router.extend
  
  initialize: ->
    app.routes['dashboard#index'] = ''

  routes:
    "" : "index"
    "/": "index"

  index: ->
    Events.trigger "navigation:go", "dashboard"
    app.rootWindow.pushRootView new DashboardIndex

$ ->
  app.registerRouter( DashboardRouter )
