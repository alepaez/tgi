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

  def top_products_won_deals
    top(@account.products.joins("INNER JOIN deal_items JOIN deals").where("deal_items.product_id = products.id AND deal_items.deal_id = deals.id AND deals.status = 'won'").group(:description).order("count_deal_items_deal_id DESC").count("deal_items.deal_id"), 3)
  end

  def top_products_lost_deals
    top(@account.products.joins("INNER JOIN deal_items JOIN deals").where("deal_items.product_id = products.id AND deal_items.deal_id = deals.id AND deals.status = 'lost'").order("count_deal_items_deal_id DESC").group(:description).count("deal_items.deal_id"), 3)
  end

  private

  def top(hash, number)
    resp = {}
    keys = hash.keys[0..number-1]
    resp.merge! hash.slice(*keys)
    other = hash.except(*keys).values.sum
    resp.merge!({ "outros" => other }) if other > 0
    resp
  end

  def income_week(day)
    deals = Deal.joins(:contact).where('contacts.account_id = ? and deals.updated_at >= ? and deals.updated_at <= ?', @account.id, day.beginning_of_week, day.end_of_week).only_won
    deals.sum(&:total_cents)
  end

  
end
