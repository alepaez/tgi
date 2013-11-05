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
    @dashboard.getTopProductsDeals(@dataLoaded)
    @

  context: ->
    dashboard: @dashboard
  
  dataLoaded: ->
    @loadCount++
    @load() if @loadCount >= 3

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

    options =
      legend:
        show: false
      series:
        pie:
          show: true
          stroke:
            color: '#F7F7F7'
          label:
            show: true
            radius: 15/16
            formatter: (label, series) ->
              "<div style='font-size:small;text-align:center;padding: 5px;color: white'>#{label}<br/>#{Math.round(series.percent)}%</div>"
            background:
              opacity: 0.5
              color: '#000'

    values = []
    for key in _.keys(@dashboard.top_products_deals.won)
      values.push {label: key, data: @dashboard.top_products_deals.won[key] }

    $.plot "#top_products_won_deals", values, options

    values = []
    for key in _.keys(@dashboard.top_products_deals.lost)
      values.push {label: key, data: @dashboard.top_products_deals.lost[key] }

    $.plot "#top_products_lost_deals", values, options

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
