require 'rails_helper'

RSpec.describe PasswordResetController, :type => :controller do
	let(:user) { FactoryGirl.create(:user) }
	
	let(:unexisting_email) { "some_random_email@email.not" }
	let(:create_options) { { user: { email: user.email } } }
	let(:invalid_create_options) { { user: { email: unexisting_email } } }
	let(:update_options) { { id: user.resettoken, user: { password: "asdfasdf", password_confirmation: "asdfasdf" } } }
	let(:invalid_update_options ) { { id: user.resettoken, user: { password: "asdf", password_confirmation: "asdfasdf" } } }
	
	subject { response }

	describe "GET 'new'" do
		before { get :new }
		it { should be_success }
	end
	
	describe "POST 'create'" do
		describe "with a valid email" do
			it "forwards to login_path" do
				post :create, create_options
				expect(response).to redirect_to login_path
			end
			
			it "modifies the users reset token" do
				expect{ post :create, create_options }.to change { user.reload.resettoken }
			end
			it "modifies the reset time" do
				expect{ post :create, create_options }.to change { user.reload.resettime }
			end
		end
		
		describe "with an invalid email" do
			it "sets @email as the parameter passed" do
				post :create, invalid_create_options
				expect(assigns(:email)).to eq unexisting_email
			end
			it "renders the new template" do
				post :create, invalid_create_options
				expect(response).to render_template "new"
			end
		end
	end

	describe "GET 'edit'" do
		describe "with a valid token" do
			before do 
				user.create_reset_password_token 
				get :edit, { id: user.resettoken }
			end
			it { should be_success }
		end
		describe "with an expired token" do
			before do
				user.create_reset_password_token
				user.resettime = 24.hours.ago
				user.save
				get :edit, { id: user.resettoken }
			end
			it { should redirect_to root_url }
		end
		
		describe "with an invalid token" do
			before do
				get :edit, { id: "asdf" }
			end
			it { should redirect_to root_url }
		end
	end
	
	describe "PUT 'update'" do
		describe "with valid params" do
			before do 
				user.create_reset_password_token
				put :update, update_options
			end
			it { should redirect_to user }
			it "should log in the user" do
				expect(assigns(:current_user)).to eq user
			end
		end
		describe "with invalid params" do
			before do
				user.create_reset_password_token
				put :update, invalid_update_options
			end
			it { should render_template "edit" }
			it "should have the proper error messages" do
				expect(assigns(:errors)).to eq [I18n.t(:password_and_confirmation_must_match), I18n.t(:password_and_confirmation_must_be_longer)]
			end
		end
	end
end
