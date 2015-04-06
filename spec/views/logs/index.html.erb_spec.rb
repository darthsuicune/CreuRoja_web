require 'rails_helper'

describe "logs/index" do
	let(:user) { FactoryGirl.create(:admin) }
	let(:log) { FactoryGirl.create(:log) }

	before(:each) do
		user.save
		sign_in user
		log.user_id = user.id
		log.save
	end

	it "renders a list of logs" do
		render
		# Run the generator again with the --webrat flag if you want to use webrat matchers
		expect(rendered).to match user.name
		expect(rendered).to match user.surname
		expect(rendered).to match user.email
		expect(rendered).to match log.action
		expect(rendered).to match log.formatted_controller
		expect(rendered).to match log.ip
		expect(rendered).to match log.created_at.to_s
	end
end
