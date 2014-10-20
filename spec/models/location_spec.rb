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
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:subassembly) { FactoryGirl.create(:assembly, depends_on: assembly.id) }
		let(:service) { FactoryGirl.create(:service, end_time: 1.month.from_now, assembly_id: subassembly.id) }
		let(:user) { FactoryGirl.create(:user) }
		before do
			user.add_to_assembly(assembly)
			service.add_location(location1)
			location2.save
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
		let(:acu) { FactoryGirl.create(:user) }
		let(:asi) { FactoryGirl.create(:user) }
		let(:b1) { FactoryGirl.create(:user) }
		let(:btp) { FactoryGirl.create(:user) }
		let(:d1) { FactoryGirl.create(:user) }
		let(:per) { FactoryGirl.create(:user) }
		let(:soc) { FactoryGirl.create(:user) }
		before do
			acu.add_type("acu")
			asi.add_type("asi")
			b1.add_type("b1")
			btp.add_type("btp")
			d1.add_type("d1")
			per.add_type("per")
			soc.add_type("soc")
		end
		
		describe "asamblea" do
			let(:asamblea) { FactoryGirl.create(:location, location_type: "asamblea") }
			it "should be visible for all" do
				expect(acu.locations).to match_array([asamblea])
				expect(asi.locations).to match_array([asamblea])
				expect(b1.locations).to match_array([asamblea])
				expect(btp.locations).to match_array([asamblea])
				expect(d1.locations).to match_array([asamblea])
				expect(per.locations).to match_array([asamblea])
				expect(soc.locations).to match_array([asamblea])
			end
		end
		
		describe "cuap" do
			let(:cuap) { FactoryGirl.create(:location, location_type: "cuap") }
			it "should be visible for all" do
				expect(acu.locations).to match_array([cuap])
				expect(asi.locations).to match_array([cuap])
				expect(b1.locations).to match_array([cuap])
				expect(btp.locations).to match_array([cuap])
				expect(d1.locations).to match_array([cuap])
				expect(per.locations).to match_array([cuap])
				expect(soc.locations).to match_array([cuap])
			end
		end
		
		describe "gasolinera" do
			let(:gasolinera) { FactoryGirl.create(:location, location_type: "gasolinera") }
			it "should be visible for b1, d1, btp" do
				expect(acu.locations).to match_array([])
				expect(asi.locations).to match_array([])
				expect(b1.locations).to match_array([gasolinera])
				expect(btp.locations).to match_array([gasolinera])
				expect(d1.locations).to match_array([gasolinera])
				expect(per.locations).to match_array([])
				expect(soc.locations).to match_array([])
			end
		end
		
		describe "hospital" do
			let(:hospital) { FactoryGirl.create(:location, location_type: "hospital") }
			it "should be visible for all" do
				expect(acu.locations).to match_array([hospital])
				expect(asi.locations).to match_array([hospital])
				expect(b1.locations).to match_array([hospital])
				expect(btp.locations).to match_array([hospital])
				expect(d1.locations).to match_array([hospital])
				expect(per.locations).to match_array([hospital])
				expect(soc.locations).to match_array([hospital])
			end
		end
		
		describe "salvamento" do
			let(:salvamento) { FactoryGirl.create(:location, location_type: "salvamento") }
			it "should be visible for acu, per" do
				expect(acu.locations).to match_array([salvamento])
				expect(asi.locations).to match_array([])
				expect(b1.locations).to match_array([])
				expect(btp.locations).to match_array([])
				expect(d1.locations).to match_array([])
				expect(per.locations).to match_array([salvamento])
				expect(soc.locations).to match_array([])
			end
		end
		
		describe "nostrum" do
			let(:nostrum) { FactoryGirl.create(:location, location_type: "nostrum") }
			it "should be visible for all" do
				expect(acu.locations).to match_array([nostrum])
				expect(asi.locations).to match_array([nostrum])
				expect(b1.locations).to match_array([nostrum])
				expect(btp.locations).to match_array([nostrum])
				expect(d1.locations).to match_array([nostrum])
				expect(per.locations).to match_array([nostrum])
				expect(soc.locations).to match_array([nostrum])
			end
		end
		
		describe "terrestre" do
			let(:terrestre) { FactoryGirl.create(:location, location_type: "terrestre") }
			it "should be visible for asi" do
				expect(acu.locations).to match_array([])
				expect(asi.locations).to match_array([terrestre])
				expect(b1.locations).to match_array([])
				expect(btp.locations).to match_array([])
				expect(d1.locations).to match_array([])
				expect(per.locations).to match_array([])
				expect(soc.locations).to match_array([])
			end
		end
		
		describe "maritimo" do
			let(:maritimo) { FactoryGirl.create(:location, location_type: "maritimo") }
			it "should be visible for acu, per" do
				expect(acu.locations).to match_array([maritimo])
				expect(asi.locations).to match_array([])
				expect(b1.locations).to match_array([])
				expect(btp.locations).to match_array([])
				expect(d1.locations).to match_array([])
				expect(per.locations).to match_array([maritimo])
				expect(soc.locations).to match_array([])
			end
		end
		
		describe "adaptadas" do
			let(:adaptadas) { FactoryGirl.create(:location, location_type: "adaptadas") }
			it "should be visible for soc" do
				expect(acu.locations).to match_array([])
				expect(asi.locations).to match_array([])
				expect(b1.locations).to match_array([])
				expect(btp.locations).to match_array([])
				expect(d1.locations).to match_array([])
				expect(per.locations).to match_array([])
				expect(soc.locations).to match_array([adaptadas])
			end
		end
		
		describe "bravo" do
			let(:bravo) { FactoryGirl.create(:location, location_type: "bravo") }
			it "should be visible for asi" do
				expect(acu.locations).to match_array([])
				expect(asi.locations).to match_array([bravo])
				expect(b1.locations).to match_array([])
				expect(btp.locations).to match_array([])
				expect(d1.locations).to match_array([])
				expect(per.locations).to match_array([])
				expect(soc.locations).to match_array([])
			end
		end
	end
	
	describe "allowed_types" do
		let(:user) { FactoryGirl.create(:user) }
		let(:acu) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "acu") }
		let(:asi) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "asi") }
		let(:b1) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "b1") }
		let(:btp) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "btp") }
		let(:d1) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "d1") }
		let(:per) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "per") }
		let(:soc) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "soc") }
		
		it "should return proper values" do
			expect(Location.allowed_types([b1, per])).to match_array(["asamblea","cuap","hospital", "nostrum", "gasolinera", "salvamento", "maritimo"])
		end
	end
end