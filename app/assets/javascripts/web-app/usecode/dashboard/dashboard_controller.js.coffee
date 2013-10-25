class DashboardController extends ApplicationController

@DashboardController = DashboardController

class DashboardIndex extends DashboardController
  layout: 'dashboard/index'
  
  initialize: ->
    super
    that = @

    @dashboard = new app.Dashboard

    @enableLoader()
    @loadCount = 0
    @dashboard.getRecentIncome(@dataLoaded)
    @dashboard.getLast12WeeksIncome(@dataLoaded)
    @

  context: ->
    dashboard: @dashboard
  
  dataLoaded: ->
    @loadCount++
    @load() if @loadCount >= 2

  render: ->
    super

    values = []
    keys = _.keys(@dashboard.last_12_weeks_income)
    count = 0
    for value in _.values(@dashboard.last_12_weeks_income)
      values.push [ count, value.cents ]
      count++

    lastYear = ""

    options =
      shadowSize: 0
      grid:
        borderColor: '#E9E9E9'
        borderWidth: 1
      xaxis:
        tickDecimals: 0
        tickFormatter: (val, axis) ->
          date = keys[val].split('-')
          label = "#{date[2]}/#{date[1]}"
          label = label + "<br/>" + date[0] if this.lastYear != date[0]
          this.lastYear = date[0]
          label
      yaxis:
        min: 0
        tickDecimals: 0
        tickFormatter: (val, axis) ->
          if(val > 0) then "R$#{val/100.0}" else  ""
      series:
        color: '#95C535'
        lines:
          lineWidth: 4
          show: true
          fill: true
          fillColor: '#538115'
        points:
          show: true
          radius: 4
          fill: true
          fillColor: '#95C535'

    $.plot '#last_12_weeks_income', [values], options

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
