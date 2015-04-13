require 'rails_helper'

describe "locations/show" do
	let(:user) { FactoryGirl.create(:admin) }
	let(:assembly) { FactoryGirl.create(:assembly) }
	before(:each) do
		sign_in user
		user.add_to_assembly(assembly)
		@location = FactoryGirl.create(:location)
		@assembly_location = AssemblyLocation.new
	end

	it "renders attributes in <p>" do
		render
		# Run the generator again with the --webrat flag if you want to use webrat matchers
		expect(rendered).to match(/Name/)
		expect(rendered).to match(/Description/)
		expect(rendered).to match(/Address/)
		expect(rendered).to match(/Phone/)
		expect(rendered).to match(/1.5/)
		expect(rendered).to match(/1.5/)
		expect(rendered).to match(/hospital/)
		expect(rendered).to match(/true/)
		expect(rendered).to match(/assign_location_to_assembly/)
	end
end
