class Api::V1::DashboardController < Api::V1::BaseController

  def recent_income
    @income_last_week = graphic_gen.income_last_week
    @income_this_week = graphic_gen.income_this_week
    @growth_percent = @income_last_week == 0 ? 0 : (((@income_this_week-@income_last_week)/@income_last_week.to_f)*100).round(2)
    render json: {last_week: "R$#{Money.new(@income_last_week, 'BRL')}", this_week: "R$#{Money.new(@income_this_week, 'BRL')}", growth_percent: @growth_percent }
  end

  def last_12_weeks_income_comparison
    income_last_12_weeks = graphic_gen.income_last_12_weeks
    income_last_12_weeks.each do |week,income|
      income_last_12_weeks[week] = { "cents" => income.to_s, "localized" =>"R$#{Money.new(income, 'BRL')}" }
    end
    render json: income_last_12_weeks
  end

  def top_products_deals
    render json: { won: graphic_gen.top_products_won_deals, lost: graphic_gen.top_products_lost_deals }
  end

  private

  def graphic_gen
    @graphic_gen ||= GraphicGenerator.new(@account)
  end
  
end
