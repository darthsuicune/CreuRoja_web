require 'rails_helper'

RSpec.describe Province, :type => :model do
	let(:province) { FactoryGirl.create(:province) }
	subject { province }
	
	it { should respond_to(:users) }
	it { should respond_to(:locations) }
	it { should respond_to(:assembly) }
end
