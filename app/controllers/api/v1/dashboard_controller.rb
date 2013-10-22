class Api::V1::DashboardController < Api::V1::BaseController

  def recent_income
    @income_last_week = graphic_gen.income_last_week
    @income_this_week = graphic_gen.income_this_week
    @growth_percent = @income_last_week == 0 ? 0 : ((@income_this_week-@income_last_week)/@income_last_week)*100
    render json: {last_week: "R$#{Money.new(@income_last_week, 'BRL')}", this_week: "R$#{Money.new(@income_this_week, 'BRL')}", growth_percent: @growth_percent }
  end

  def last_12_weeks_income_comparison
  end

  private

  def graphic_gen
    @graphic_gen ||= GraphicGenerator.new(@account)
  end
  
end
