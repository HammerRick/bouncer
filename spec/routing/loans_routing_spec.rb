require "rails_helper"

RSpec.describe Api::V1::LoansController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api/v1/loans").to route_to("api/v1/loans#index")
    end

    it "routes to #show" do
      expect(get: "/api/v1/loans/1").to route_to("api/v1/loans#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/api/v1/loans").to route_to("api/v1/loans#create")
    end
  end
end
