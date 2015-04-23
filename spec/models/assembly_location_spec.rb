require 'rails_helper'

RSpec.describe AssemblyLocation, :type => :model do
	let(:location) { FactoryGirl.create(:location) }
	let(:assembly_location) { FactoryGirl.create(:assembly_location, location_id: location.id) }
	subject { assembly_location }
	
	it { should respond_to(:location) }
	it { should respond_to(:assembly) }
	
	describe "notify update" do
		it "should update the location updated_at field" do
			expect {
				assembly_location.save
			}.to change(assembly_location.location, :updated_at)
		end
	end
end
