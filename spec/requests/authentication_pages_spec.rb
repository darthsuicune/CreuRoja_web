require 'rails_helper'

describe "Authentication Pages" do
	let(:user) { FactoryGirl.create(:user) }
	before do
		user.save
		visit signin_path 
	end
	subject { page }
	describe "login" do
		it { should have_title(I18n.t(:login)) }
		it { should have_content(I18n.t(:login)) }

		describe "with invalid information" do
			before { click_button I18n.t(:login_button) }
			it { should have_selector('div.error') }
		end

		describe "with valid information" do
			before do
				fill_in I18n.t(:form_user_email), with: user.email.upcase
				fill_in I18n.t(:form_user_password), with: user.password
				click_button I18n.t(:login_button)
			end
			it "should redirect to the map" do
				expect(body).to match('<div id="map">')
			end
		end
	end
end
