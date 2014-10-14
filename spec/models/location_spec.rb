require 'rails_helper'

describe Location do
	let(:location) { FactoryGirl.create(:location) }
	
	subject { location }
	
	it { should respond_to("latitude") }
	it { should respond_to("longitude") }
	it { should respond_to("name") }
	it { should respond_to("address") }
	it { should respond_to("location_type") }
	it { should respond_to("services") }
	it { should respond_to("active") }
	
	describe "with invalid parameters" do
		describe "without name" do
			before { location.name = nil }
			it { should_not be_valid }
		end
		describe "without address" do
			before { location.address = nil }
			it { should_not be_valid }
		end
		describe "without latitude" do
			before { location.latitude = nil }
			it { should_not be_valid }
		end
		describe "without longitude" do
			before { location.longitude = nil }
			it { should_not be_valid }
		end
		describe "without type" do
			before { location.location_type = nil }
			it { should_not be_valid }
		end
	end
	
	describe "offices" do
		let(:location1) { FactoryGirl.create(:location, location_type: "asamblea") }
		it "should display only assemblies" do
			expect(Location.offices).to match_array([location1])
		end
	end
	
	describe "active locations" do
		let(:location1) { FactoryGirl.create(:location, active: false) }
		it "should display only active locations" do
			expect(Location.active_locations).to match_array([location])
		end
	end
	
	describe "types" do
		let(:location1) { FactoryGirl.create(:location, location_type: "asdf") }
		let(:location2) { FactoryGirl.create(:location, location_type: "asdf") }
		before {
			location.save
			location1.save
			location2.save
		}
		it "should display all location types" do
			expect(Location.location_types).to be_an(ActiveRecord::Relation)
		end
		it "should contain only the current types" do
			types = Location.location_types
			expect(types[0].location_type).to eq("asdf")
			expect(types[1].location_type).to eq("MyType")
		end
	end
	
	describe "is general" do
		let(:location1) { FactoryGirl.create(:location, location_type: "terrestre") }
		let(:location2) { FactoryGirl.create(:location, location_type: "hospital") }
		before do
			location.save
			location1.save
		end
		
		it "should be true for 1, false for 2" do
			expect(location1.general?).to be false
			expect(location2.general?).to be true
		end
	end
	
	describe "serviced locations" do
		let(:location1) { FactoryGirl.create(:location, location_type: "terrestre") }
		let(:location2) { FactoryGirl.create(:location, location_type: "hospital") }
		let(:location3) { FactoryGirl.create(:location, location_type: "maritimo") }
		let(:service1) { FactoryGirl.create(:service, end_time: 1.month.from_now) }
		let(:assembly) { FactoryGirl.create(:assembly, id: 1) }
		let(:user) { FactoryGirl.create(:user) }
		before do
			assembly.save
			user.save
			location1.save
			location2.save
			location3.save
			service1.save
			ua = user.user_assemblies.create(assembly_id: service1.assembly_id)
			ua.save
			ls = service1.location_services.create(location_id: location1.id)
			ls.save
		end
		
		it "should be a relation" do
			expect(Location.serviced user).to be_an(ActiveRecord::Relation)
		end
		
		it "should list general and serviced but not without assigned services" do
			locations = Location.serviced user
			expect(locations).to include(location1)
			expect(locations).to include(location2)
			expect(locations).not_to include(location3)
		end
	end

	describe "filter_by_user_types" do
		let(:user) { FactoryGirl.create(:user) }
		let(:user_types) { ["b1","soc"] }
		before do
		end
		it "should show a filtered list" do
			locations = Location.filter_by_user_types(user_types)
		end
	end
end
