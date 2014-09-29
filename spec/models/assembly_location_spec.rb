require 'rails_helper'

RSpec.describe AssemblyLocation, :type => :model do
	let(:assembly_location) { FactoryGirl.create(:assembly_location) }
	subject { assembly_location }
	
	it { should respond_to(:location) }
	it { should respond_to(:assembly) }
end
