require 'rails_helper'

RSpec.describe Log, :type => :model do
	let(:log) { FactoryGirl.create(:log) }
	subject { log }
	
	it { should respond_to(:user_id) }
	it { should respond_to(:controller) }
	it { should respond_to(:action) }
	it { should respond_to(:ip) }
	it { should respond_to(:link) }
	it { should respond_to(:has_link) }
	it { should respond_to(:action_success) }
	it { should respond_to(:requested_param) }
	
	describe "formatted_controller" do
		it "should return a formatted string for composite controllers" do
			log.controller = "something_some"
			expect(log.formatted_controller).to eq("relation something some")
		end
		
		it "should return the controller name for non-composite controllers" do
			expect(log.formatted_controller).to eq(log.controller)
		end
	end
	
	describe "link" do
		it "should return a properly formatted link" do
			expect(log.link).to eq "#{log.controller}/#{log.requested_param}"
		end
	end
	
	describe "has_link" do
		it "should return true for non-composite models" do
			expect(log.has_link).to be_truthy
		end
			
		it "should return false for composite models" do
			log.controller = "something_some"
			expect(log.has_link).to be_falsey
		end
	end
end
