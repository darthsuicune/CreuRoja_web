require 'rails_helper'

RSpec.describe ApplicationController, :type => :controller do
	let(:user) { FactoryGirl.create(:user) }
	before { sign_in user }
	controller do
		def index
			render 'locations/index'
		end
		def edit
			not_found
		end
	end
	describe "locale" do
		it "should be set" do
			allow(I18n).to receive('locale=')
			get :index, { locale: "ca" }
			expect(I18n).to have_received('locale=').with "ca"
		end
	end
	
	describe "not_found" do
		it "should return a properly formatted 404 page" do
			expect {get :edit, { id: 0 } }.to raise_error ActiveRecord::RecordNotFound
		end
	end
end