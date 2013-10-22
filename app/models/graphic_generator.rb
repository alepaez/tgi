class GraphicGenerator
  def initialize(account)
    @account = account
  end

  def income_this_week
    deals = Deal.joins(:contact).where('contacts.account_id = ? and deals.updated_at >= ?', @account.id, Date.today.beginning_of_week).only_won
    deals.sum(&:total_cents)
  end

  def income_last_week
    income_week(1.week.ago)
  end

  def income_last_12_weeks
    result = {}
    (0..11).to_a.reverse.each do |i|
      date = Date.today - i.weeks
      result[date.beginning_of_week.strftime("%Y-%m-%d")] = income_week(date)
    end
    result
  end

  private

  def income_week(day)
    deals = Deal.joins(:contact).where('contacts.account_id = ? and deals.updated_at >= ? and deals.updated_at <= ?', @account.id, day.beginning_of_week, day.end_of_week).only_won
    deals.sum(&:total_cents)
  end

  
end
