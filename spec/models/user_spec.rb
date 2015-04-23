require 'rails_helper'

describe User do
	let(:pass) { "foobar" }
	before { @user = User.new( name: "Example", surname: "Example", email: "user@example.com", 
										role: "volunteer", password: pass, password_confirmation: pass ) }
	subject { @user }

	it { should respond_to(:name) }
	it { should respond_to(:surname) }
	it { should respond_to(:email) }
	it { should respond_to(:role) }
	it { should respond_to(:language) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:active) }
	it { should respond_to(:allowed_to?) }
	it { should respond_to(:sessions) }
	it { should respond_to(:user_types) }
	it { should respond_to(:assemblies) }
	it { should respond_to(:services) }
	it { should respond_to(:resettoken) }
	it { should respond_to(:resettime) }

	it { should be_valid }

	describe "name" do
		describe "is not present" do
			before { @user.name = " " }
			it { should_not be_valid }
		end
		describe "is waaaay too long" do
			before { @user.name = "abcdefghijklmnopqrstuvwxyz" * 4 }
			it { should_not be_valid }
		end
	end
	
	describe "surname" do
		describe "is not present" do
			before { @user.surname = " " }
			it { should_not be_valid }
		end
		describe "is waaaay too long" do
			before { @user.surname = "abcdefghijklmnopqrstuvwxyz" * 4 }
			it { should_not be_valid }
		end
	end
	
	describe "email" do
		describe "is not present" do
			before { @user.email = " " }
			it { should_not be_valid }
		end
		describe "format is invalid" do
			it "should be invalid" do
				addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
				addresses.each do |invalid_address|
					@user.email = invalid_address
					expect(@user).not_to be_valid
				end
			end
		end
		describe "format is valid" do
			it "should be valid" do
				addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
				addresses.each do |valid_address|
					@user.email = valid_address
					expect(@user).to be_valid
				end
			end
		end
		describe "is already taken" do
			before do
				user2 = @user.dup
				user2.email = @user.email.upcase
				user2.save
			end
			it { should_not be_valid }
		end
		describe "is not downcased" do
			let(:email1) { "dEnIs@localhost.com" }
			it "should be lower case" do
				@user.email = email1
				@user.save
				expect(@user.reload.email).to eq(email1.downcase)
			end
		end
	end
	
	describe "password" do
		describe "is not present" do
			before { @user.password = @user.password_confirmation = " " }
			it { should_not be_valid }
		end
		describe "is too short" do
			before { @user.password = @user.password_confirmation = "a" * 5 
			         @user.save }
			it { should_not be_valid }
		end
		describe "isn't matching confirmation" do
			before { @user.password_confirmation = "mismatch" }
			it { should_not be_valid }
		end
		describe "confirmation is nil" do
			before { @user.password = "asdfgh"
						@user.password_confirmation = nil
						@user.save}
			it { should_not be_valid }
		end
	end
	
	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }
		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end
		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			
			it { should_not eq(user_for_invalid_password) }
			it "should be false" do
				expect(user_for_invalid_password).to be_falsey
			end
		end
	end
	
	describe "permission system" do
		describe "admins" do
			before { @user.role = "admin"
						@user.save }
			it { should be_allowed_to(:manage_admin_users) }
			it { should be_allowed_to(:see_own_profile) }
		end
		describe "technicians" do
			before { @user.role = "technician"
						@user.save }
			it { should be_allowed_to(:see_own_profile) }
			it { should be_allowed_to(:manage_users) }
			it { should_not be_allowed_to(:manage_admin_users) }
		end
		describe "volunteers" do
			before { @user.role = "volunteer"
						@user.save }
			it { should be_allowed_to(:see_own_profile) }
			it { should_not be_allowed_to(:manage_technician_users) }
			it { should_not be_allowed_to(:manage_admin_users) }
		end
		describe "a blocked user" do
			before { @user.active = false
						@user.save }
			it { should_not be_allowed_to(:see_own_profile) }
		end
	end
	
	describe "create_reset_password_token" do
		let(:user) { FactoryGirl.create(:user) }
		it "creates a token" do
			expect {
				user.create_reset_password_token
			}.to change(user, :resettoken)
		end
		it "sets the resettime to now" do
			user.create_reset_password_token
			expect(user.resettime).to be_within(5.seconds).of(Time.now)
		end
		it "can create tokens that last further" do
			user.create_reset_password_token(1.year.from_now)
			expect(user.resettime).to be_within(5.seconds).of(1.year.from_now)
		end
	end
	
	describe "reset_password(password)" do
		let(:new_password) { "fdsa"*2 }
		it "resets the password" do
			expect {
				@user.reset_password new_password
			}.to change(@user, :password_digest)
		end
		it "authenticates with the new one" do
			@user.reset_password new_password
			result = @user.authenticate new_password
			expect(result).to be @user
		end
		it "doesn't authenticate with the old one" do
			@user.reset_password new_password
			result = @user.authenticate pass
			expect(result).to be_falsey
		end
	end
	
	describe "create_session_token" do
		let(:user) { FactoryGirl.create(:user) }
		it "creates a session" do
			expect {
				user.create_session_token
			}.to change(Session, :count).by(1)
		end
	end
	
	describe "vehicles" do
		let(:vehicle1) { FactoryGirl.create(:vehicle) }
		let(:vehicle2) { FactoryGirl.create(:vehicle) }
		let(:vehicle3) { FactoryGirl.create(:vehicle) }
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:vehicle_assembly) { FactoryGirl.create(:vehicle_assembly, assembly_id: assembly.id, vehicle_id: vehicle1.id) }
		let(:vehicle_assembly1) { FactoryGirl.create(:vehicle_assembly, assembly_id: assembly.id, vehicle_id: vehicle3.id) }
		let(:vehicle_assembly2) { FactoryGirl.create(:vehicle_assembly, assembly_id: assembly.id + 1, vehicle_id: vehicle2.id) }
		before {
			vehicle1.save
			vehicle2.save
			vehicle3.save
			vehicle_assembly.save
			vehicle_assembly1.save
			vehicle_assembly2.save
		}
		
		describe "for normal users" do
			let(:user) { FactoryGirl.create(:user) }
			let(:user_assembly) { FactoryGirl.create(:user_assembly, assembly_id: assembly.id, user_id: user.id) }
			
			before {
				user.save
				user_assembly.save
			}
			
			it "the array contains only the vehicles from the same assembly" do
				expect(user.vehicles).to match_array([vehicle1, vehicle3])
				expect(user.vehicles).to be_an(ActiveRecord::Relation)
			end
		end
		
		describe "for admins" do
			let(:admin) { FactoryGirl.create(:admin) }
			let(:user_assembly) { FactoryGirl.create(:user_assembly, assembly_id: assembly.id, user_id: admin.id) }
			before {
				admin.save
				user_assembly.save
			}

			it "the array contains all vehicles" do
				expect(admin.vehicles).to match_array([vehicle1, vehicle3, vehicle2])
				expect(admin.vehicles).to be_an(ActiveRecord::Relation)
			end
		end
	end

	describe "available_services" do
		let(:assembly1) { FactoryGirl.create(:assembly) }
		let(:assembly2) { FactoryGirl.create(:assembly) }
		let(:assembly3) { FactoryGirl.create(:assembly) }
		let(:service1) { FactoryGirl.create(:service, assembly_id: assembly1.id) }
		let(:service2) { FactoryGirl.create(:service, assembly_id: assembly2.id) }
		let(:service3) { FactoryGirl.create(:service, assembly_id: assembly3.id) }
		let(:user1) { FactoryGirl.create(:user) }
		before do
			user1.add_to_assembly(assembly1)
			user1.add_to_assembly(assembly2)
		end
		it "should return services that are available to the user assembly" do
			expect(user1.available_services).to match_array([service1, service2])
		end
	end
	
	describe "assembly_users" do
		let(:assembly1) { FactoryGirl.create(:assembly) }
		let(:assembly2) { FactoryGirl.create(:assembly) }
		let(:assembly3) { FactoryGirl.create(:assembly) }
		let(:user1) { FactoryGirl.create(:user) }
		let(:user2) { FactoryGirl.create(:user) }
		let(:user3) { FactoryGirl.create(:user) }
		let(:user4) { FactoryGirl.create(:user) }
		before do
			user1.add_to_assembly(assembly1)
			user2.add_to_assembly(assembly2)
			user3.add_to_assembly(assembly3)
			user4.add_to_assembly(assembly1)
			user4.add_to_assembly(assembly2)
		end
		it "should return the users that share an assembly with the user" do
			expect(user4.assembly_users).to match_array([user1, user2, user4])
		end
	end

	describe "for_session" do
		before do
			@user.save
			@user.sessions.create(token: "asdf")
			@user.user_types.create(user_type: "b1")
		end
		
		it "should return a hash with the correct values" do
			expect(@user.for_session).to be_a(Hash)
			expect(@user.for_session[:id]).to eq(@user.id)
			expect(@user.for_session[:name]).to eq(@user.name)
			expect(@user.for_session[:surname]).to eq(@user.surname)
			expect(@user.for_session[:email]).to eq(@user.email)
			expect(@user.for_session[:phone]).to eq(@user.phone)
			expect(@user.for_session[:accessToken]).to eq(@user.sessions.last.token)
			expect(@user.for_session[:role]).to eq(@user.role)
			expect(@user.for_session[:active]).to eq(@user.active)
			expect(@user.for_session[:types]).to eq(@user.types)
		end
	end

	describe "assembly_ids" do
		let(:assembly1) { FactoryGirl.create(:assembly) }
		let(:assembly2) { FactoryGirl.create(:assembly) }
		let(:assembly3) { FactoryGirl.create(:assembly) }
		let(:assembly4) { FactoryGirl.create(:assembly) }
		let(:user) { FactoryGirl.create(:user) }
		before do
			assembly2.depends_on = assembly1.id
			assembly2.save
			assembly3.depends_on = -1
			user.add_to_assembly(assembly1)
		end
		it "should contain the ids of its assemblies and dependants, but not others" do
			expect(user.assembly_ids).to match_array([assembly1.id, assembly2.id])
		end
	end

	describe "add_type" do
		let(:user) { FactoryGirl.create(:user) }
		it "should add the user the type" do
			expect {
				user.add_type("something")
			}.to change(UserType, :count).by(1)
		end
	end

	describe "goes_to" do
		let(:user) { FactoryGirl.create(:user) }
		let(:service) { FactoryGirl.create(:service) }
		before do
			service.save
			user.sign_up_for_service service, "position"
		end
		it "should return true if the user goes" do
			expect(user.goes_to?(service)).to be_truthy
		end
	end
	
	describe "in assembly of" do
		let(:user) { FactoryGirl.create(:user) }
		let(:user2) { FactoryGirl.create(:user) }
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:assembly2){ FactoryGirl.create(:assembly) }
		before do
			@user.save
			@user.add_to_assembly assembly
			user.add_to_assembly assembly
			user2.add_to_assembly assembly2
		end
		it "should be in user assembly" do
			expect(@user).to be_in_assembly_of(user)
		end
		it "shouldnt be in user assembly" do
			expect(@user).not_to be_in_assembly_of(user2)
		end
	end
	
	describe "map_elements" do
		let(:location) { FactoryGirl.create(:location) }
		let(:location1) { FactoryGirl.create(:location, location_type: "terrestre") }
		let(:admin) { FactoryGirl.create(:admin) }
		describe "for admin" do
			it "should match the full location list" do
				expect(admin.map_elements "autonomica").to match_array([location1,location])
			end
		end
		describe "for user" do
			let(:assembly) { FactoryGirl.create(:assembly) }
			before do
				assembly.save
				@user.save
				@user.add_to_assembly assembly
				location.add_to_assembly assembly
			end
			it "should match the locations the user can see" do
				expect(@user.map_elements "autonomica").to include location
				expect(@user.map_elements "autonomica").not_to include location1
			end
		end
	end
	
	describe "add_to_service" do
		let(:service) { FactoryGirl.create(:service) }
		let(:vehicle) { FactoryGirl.create(:vehicle) }
		let(:location) { FactoryGirl.create(:location) }
		let(:position) { "position" }
		
		before { @user.save }
		
		it "should create a service user if passed a location" do
			expect{ @user.add_to_service_at_location(service,position,location) }.to change(ServiceUser, :count).by(1)
		end
		
		it "should create a service user if passed a vehicle" do
			expect{ @user.add_to_service_in_vehicle(service,position,vehicle) }.to change(ServiceUser, :count).by(1)
		end
	end
	
	describe "available_services" do
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:assembly1) { FactoryGirl.create(:assembly) }
		let(:service) { FactoryGirl.create(:service, assembly_id: assembly.id) }
		let(:service1) { FactoryGirl.create(:service, assembly_id: assembly1.id) }
		let(:admin) { FactoryGirl.create(:admin) }
		
		before do
			admin.save
			@user.save
			@user.add_to_assembly(assembly)
			service.save
			service1.save
		end
			
		describe "for admin" do
			it "should show all services" do
				expect(admin.available_services).to eq Service.all
			end
		end
		describe "for normal users" do
			it "should show the services available for the user" do
				expect(@user.available_services).to eq ([service])
			end
		end
	end
	
	describe "in_service" do
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:assembly1) { FactoryGirl.create(:assembly) }
		let(:location) { FactoryGirl.create(:location) }
		let(:service) { FactoryGirl.create(:service, assembly_id: assembly.id) }
		let(:service1) { FactoryGirl.create(:service, assembly_id: assembly1.id) }
		
		before do
			@user.save
			@user.add_to_assembly(assembly)
			service.add_location(location)
			service.save
			service1.save
			
		end
			
		describe "in services it has signed up for" do
			before { @user.sign_up_for_service(service, "position") }
			it "should be in" do
				expect(@user).to be_in_service (service)
			end
		end
		
		describe "in services where he was added" do
			before { @user.add_to_service_at_location(service, "position", location) }
			it "should be in" do
				expect(@user).to be_in_service (service)
			end
		end
		
		describe "in services he hasnt signed up for nor was added" do
			it "shouldnt be in" do
				expect(@user).not_to be_in_service(service1)
			end
		end
	end
	
	describe "assembly_users" do
		let(:admin) { FactoryGirl.create(:admin) }
		let(:assembly) { FactoryGirl.create(:assembly) }
		let(:assembly1) { FactoryGirl.create(:assembly) }
		let(:user) { FactoryGirl.create(:user) }
		let(:user1) { FactoryGirl.create(:user) }
		
		before do
			@user.save
			user.save
			user1.save
			user.add_to_assembly assembly
			user1.add_to_assembly assembly1
			@user.add_to_assembly assembly
		end
		describe "for admin" do
			before { admin.save }
			it "should see all users" do
				expect(admin.assembly_users).to eq User.all
			end
		end
		
		describe "for a regular user" do
			it "should see users only from his assembly" do
				expect(@user.assembly_users).to eq ([@user, user])
			end
		end
	end
	
	describe "accessable_assemblies_until_level" do
		let(:assembly) { FactoryGirl.create(:comarcal) }
		let(:user) { FactoryGirl.create(:user) }
		
		before do
			assembly.save
			user.save
			user.add_to_assembly assembly
		end
		
		describe "on a normal scenario" do
			let(:provincial) { FactoryGirl.create(:provincial) }
			let(:autonomic) { FactoryGirl.create(:autonomica) }
			before do
				assembly.depends_on = provincial.id
				provincial.depends_on = autonomic.id
				assembly.save
				provincial.save
				autonomic.save
			end
			it "should return the 3 assemblies" do
				expect(user.accessable_assemblies_until_level("autonomica")).to match_array([assembly, provincial, autonomic])
			end
		end

		describe "on independent assemblies" do
			it "should return the assembly" do
				expect(user.accessable_assemblies_until_level("autonomica")).to match_array([assembly])
			end
		end
	end
end
