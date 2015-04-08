require 'rails_helper.rb'

describe StaticPagesController do
	subject { response }
	describe "GET contact" do
		before { get :contact }
		it { should be_success }
	end
	describe "GET email_sent" do
		before { get :email_sent }
		it { should be_success }
	end
	describe "GET about" do
		before { get :about }
		it { should be_success }
	end
end