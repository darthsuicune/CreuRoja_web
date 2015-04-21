require 'rails_helper'

RSpec.describe Assembly, :type => :model do
	let(:assembly) { FactoryGirl.create(:assembly) }
	subject { assembly }
	
	it { should respond_to(:users) }
	it { should respond_to(:locations) }
	it { should respond_to(:vehicles) }
	it { should respond_to(:services) }
	it { should respond_to(:name) }
	it { should respond_to(:description) }
	it { should respond_to(:level) }
	it { should respond_to(:depends_on) }
	it { should respond_to(:address) }
	it { should respond_to(:phone) }
	it { should respond_to(:location_id) }
	it { should respond_to(:office) }
	
	describe "managed_assemblies" do
		let(:assembly1) { FactoryGirl.create(:assembly, depends_on: assembly.id) }
		let(:assembly2) { FactoryGirl.create(:assembly, depends_on: assembly1.id) }
		let(:assembly3) { FactoryGirl.create(:assembly, depends_on: nil) }
		
		before do
			assembly1.save
			assembly2.save
			assembly3.save
		end
		
		it "should retrieve child assemblies" do
			expect(assembly.managed_assemblies).to match_array([assembly, assembly1, assembly2])
		end
	end
	
	describe "managed_ids" do
		let(:assembly1) { FactoryGirl.create(:assembly, depends_on: assembly.id) }
		let(:assembly2) { FactoryGirl.create(:assembly, depends_on: assembly1.id) }
		let(:assembly3) { FactoryGirl.create(:assembly, depends_on: nil) }
		
		before do
			assembly1.save
			assembly2.save
			assembly3.save
		end
		
		it "should retrieve child assemblies" do
			expect(assembly.managed_ids).to match_array([assembly.id, assembly1.id, assembly2.id])
		end
	end
	
	describe "office" do
		let(:location) { FactoryGirl.create(:location) }
		before do
			assembly.location_id = location.id
			assembly.save
		end
		
		it "should be a location" do
			expect(assembly.office).to be_a(Location)
			expect(assembly.office.id).to be(location.id)
		end
	end
	
	describe "address" do
		let(:location) { FactoryGirl.create(:location) }
		before do
			assembly.location_id = location.id
			assembly.save
		end
		
		it "should be a location" do
			expect(assembly.address).to eq(location.address)
		end
	end
	
	describe "phone" do
		let(:location) { FactoryGirl.create(:location) }
		before do
			assembly.location_id = location.id
			assembly.save
		end
		
		it "should be a location" do
			expect(assembly.phone).to eq(location.phone)
		end
	end
	
	describe "parent" do
		let(:child) { FactoryGirl.create(:assembly, depends_on: assembly.id) }
		
		it "should return the parent" do
			expect(child.parent).to eq(assembly)
		end
	end
	
	describe "not_locals" do
		let(:local) { FactoryGirl.create(:assembly, level: "local") }
		
		it "should not include local assemblies" do
			expect(Assembly.not_locals).to match_array([assembly])
		end
	end
	
	describe "add_vehicle" do
		let(:vehicle) { FactoryGirl.create(:vehicle) }
		it "should create a new VehicleAssembly" do
			expect {
				assembly.add_vehicle(vehicle)
			}.to change(VehicleAssembly, :count). by(1)
		end
	end
	
	describe "add_user" do
		let(:user) { FactoryGirl.create(:user) }
		it "should create a new UserAssembly" do
			expect {
				assembly.add_user(user)
			}.to change(UserAssembly, :count). by(1)
		end
	end
	
	describe "add_location" do
		let(:location) { FactoryGirl.create(:location) }
		it "should create a new AssemblyLocation" do
			expect {
				assembly.add_location(location)
			}.to change(AssemblyLocation, :count). by(1)
		end
	end
	
	describe "to_s" do
		it "should show its name when being used with to_s" do
			expect(assembly.to_s).to eq assembly.name
		end
	end
	
	describe "find_autonomic" do
		let(:assembly) { FactoryGirl.create(:comarcal) }
		let(:provincial) { FactoryGirl.create(:provincial) }
		let(:autonomic) { FactoryGirl.create(:autonomica) }
		before do
			assembly.depends_on = provincial.id
			provincial.depends_on = autonomic.id
			assembly.save
			provincial.save
			autonomic.save
		end
		it "should return the autonomic assembly" do
			expect(assembly.find_parent_with_level("autonomica")).to eq autonomic
		end
	end
end
