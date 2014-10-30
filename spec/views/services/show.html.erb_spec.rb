require 'rails_helper'

describe "services/show" do
	let(:user) { FactoryGirl.create(:user) }
	let(:assembly) {FactoryGirl.create(:assembly) }
	before(:each) do
		sign_in user
		@service = FactoryGirl.create(:service)
		@service.assembly_id = assembly.id
		@service_user = ServiceUser.new
	end

	it "renders attributes in <p>" do
		render
		# Run the generator again with the --webrat flag if you want to use webrat matchers
		expect(rendered).to match(/Name/)
		expect(rendered).to match(/Description/)
		expect(rendered).to match(/MyCode/)
	end
end
