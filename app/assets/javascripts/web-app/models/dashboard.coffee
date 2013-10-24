class window.app.Dashboard extends window.app.BaseResource
  identifier: "dashboard"
  urlRoot: api_base + 'dashboard'

  initialize: ->
    super

  getRecentIncome: (cb) ->
    @configureAjax()
    that = @
    app.ajax "#{@urlRoot}/recent_income",
      type: 'GET'
      success: (data) ->
        that.recent_income = that.parse data
      complete: ->
        cb() if cb

