require 'rails_helper'

describe SessionsController do
	let(:user) { FactoryGirl.create(:user) }
	
	describe "new" do
	end
	
	describe "create" do
		describe "via JSON" do
			describe "with valid information" do
				before { post :create, { format: :json, email: user.email, password: user.password } }
				it "expect response to contain the token and user in json format" do
					expect(response.body).to eq({token: user.sessions.last.token, user: user.for_session}.to_json)
				end
			end
			
			describe "with invalid information" do
				before { post :create, { format: :json, email: "aninvalidemail", password: user.password } }
				it "expect response to be a 401 error" do
					expect(response.code).to eq "401"
				end
			end
		end
	end
	
	describe "destroy" do
		let(:session) { FactoryGirl.create(:session) }
		before { session.save }
		
		it "should log out the user" do
			delete :destroy, { token: session.token }
			expect(assigns(:current_user)).to be_nil
		end
		
		it "should redirect to root" do
			delete :destroy, { token: session.token }
			expect(response).to redirect_to root_url
		end
		
		it "should destroy the session" do
			expect{ delete :destroy, { token: session.token } }.to change(Session, :count).by(-1)
		end
	end
end
