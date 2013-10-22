require 'minitest_helper'

class GraphicGeneratorTest < ActiveSupport::TestCase
  before do
    prepare_default_env
    @product1 = @account.products.create(description: "product1", price_cents: 100)
    @product2 = @account.products.create(description: "product2", price_cents: 200)
    @contact1 = @account.contacts.create(name: "contact1", email: "contact1@example.org")
    @contact2 = @account.contacts.create(name: "contact2", email: "contact2@example.org")
    @graphic_gen = GraphicGenerator.new(@account)
  end

  describe "income_this_week method" do
    before do
      @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity:1}], status: "open")
      @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity:2}], status: "won")
      @contact2.deals.create(items_attributes: [{product_id: @product1.id, quantity:2}], status: "lost")
      @contact2.deals.create(items_attributes: [{product_id: @product2.id, quantity:1}], status: "won")
    end

    it 'should return 400' do
      assert @graphic_gen.income_this_week == 400
    end

    it 'should return 500' do
      @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity:1}], status: "won")
      assert @graphic_gen.income_this_week == 500
    end
  end

  describe "income_last_week method" do
    before do
      @deal1 = @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity:1}], status: "open")
      @deal2 = @contact2.deals.create(items_attributes: [{product_id: @product1.id, quantity:2}], status: "lost")
      @deal3 = @contact2.deals.create(items_attributes: [{product_id: @product1.id, quantity:2}], status: "won")
      @deal4 = @contact2.deals.create(items_attributes: [{product_id: @product2.id, quantity:2}], status: "won")
      @deal3.update_attribute(:updated_at, 1.week.ago)
    end

    it 'should return 200' do
      assert @graphic_gen.income_last_week == 200
    end

    it 'should return 600' do
      @deal4.update_attribute(:updated_at, 1.week.ago)
      assert @graphic_gen.income_last_week == 600
    end
  end

  describe "income_last_12_weeks method" do
    before do
      Date.stubs(:today).returns(Date.strptime("14/10/2013", "%d/%m/%Y"))
      12.times do |i|
        instance_variable_set("@deal#{i+1}", @contact1.deals.create(items_attributes: [{product_id: @product1.id, quantity: i + 1}], status: "won"))
        instance_variable_get("@deal#{i+1}").update_attribute(:updated_at, Date.today - (11 - i).weeks)
      end
    end

    it 'should return income of last 12 weeks separately' do
      assert @graphic_gen.income_last_12_weeks == {"2013-07-29"=>100,"2013-08-05"=>200,"2013-08-12"=>300,"2013-08-19"=>400,"2013-08-26"=>500,"2013-09-02"=>600,"2013-09-09"=>700,"2013-09-16"=>800,"2013-09-23"=>900,"2013-09-30"=>1000,"2013-10-07"=>1100,"2013-10-14"=>1200}
    end
    
  end
  
end
