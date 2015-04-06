require 'rails_helper'

RSpec.describe PasswordResetController, :type => :controller do
	let(:user) { FactoryGirl.create(:user) }

	describe "GET 'new'" do
		it "returns http success" do
			get 'new'
			expect(response).to be_success
		end
	end

	describe "GET 'edit'" do
		before { user.create_reset_password_token }
		it "returns http success" do
			get 'edit', { id: user.resettoken }
			expect(response).to be_success
		end
	end
end
