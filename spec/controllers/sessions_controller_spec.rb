require 'rails_helper'

describe SessionsController do
	let(:user) { FactoryGirl.create(:user, phone: "123") }
	
	describe "new" do
	end
	
	describe "create" do
		describe "with valid information" do
			before { post :create, { format: :json, email: user.email, password: user.password } }
			it "expect response to be a json object" do
				expect(response.body).to eq({token: user.sessions.last.token, user: user.for_session}.to_json)
			end
		end
	end
	
	describe "destroy" do
	end
end
