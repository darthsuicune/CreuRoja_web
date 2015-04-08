require 'rails_helper'

RSpec.describe LogsController, type: :controller do
	let(:user) { FactoryGirl.create(:user) }
	let(:tech) { FactoryGirl.create(:tech) }
	let(:admin) { FactoryGirl.create(:admin) }
	
	describe "as user" do
		before { sign_in user }
		describe "GET index" do
			before { get :index }
			it "should redirect to root" do
				expect(response).to redirect_to root_url
			end
		end
	end
	
	describe "as tech" do
		before { sign_in tech }
		describe "GET index" do
			before { get :index }
			it "should redirect to root" do
				expect(response).to redirect_to root_url
			end
		end
	end
	
	describe "as admin" do
		before { sign_in admin }
		describe "GET index" do
			before { get :index }
			it "should be successful" do
				expect(response).to render_template 'index'
			end
		end
	end
end
