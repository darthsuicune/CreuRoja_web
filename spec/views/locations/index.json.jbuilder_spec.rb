require 'rails_helper'

describe "locations/index" do
	let(:user) { FactoryGirl.create(:user) }
	let(:location) { FactoryGirl.create(:location) }
	let(:locations) { [location] }
	
	before { 
		sign_in user 
		assign(:locations, [location])
	}
	
	it "renders the correct json" do
		render template: "locations/index", formats: :json
		
		expect(rendered).to match(/id/)
		expect(rendered).to match(/name/)
		expect(rendered).to match(/description/)
		expect(rendered).to match(/address/)
		expect(rendered).to match(/phone/)
		expect(rendered).to match(/latitude/)
		expect(rendered).to match(/longitude/)
		expect(rendered).to match(/location_type/)
		expect(rendered).to match(/active/)
		expect(rendered).to match(/updated_at/)
		expect(rendered).to match(/active_services/)
	end
end