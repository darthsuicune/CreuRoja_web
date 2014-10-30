require 'rails_helper'

describe UserType do
  let(:user_type) { FactoryGirl.create(:user_type) }
  subject { user_type }
  
  it { should respond_to(:user) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user_type) }

	describe "types" do
		let(:user) { FactoryGirl.create(:user) }
		describe "assign type" do
			it "should create a user_type" do
				expect { user.user_types.build(user_type: "asdf")
							user.save }.to change(UserType, :count).by(1)
			end
		end

		describe "to user that already has it" do
			it "should fail" do
				expect { user.user_types.build(user_type: "asdf")
							user.user_types.build(user_type: "asdfasdf")
							user.save
							user.user_types.build(user_type: "asdf")
							user.save }.to raise_error
			end
		end
	end
	
	describe "available types for user" do
		let(:user) { FactoryGirl.create(:user) }
		let(:user_type1) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "asi") }
		let(:user_type2) { FactoryGirl.create(:user_type, user_id: user.id, user_type: "acu") }
		
		it "should return the proper data" do
			expect(UserType.available_types(user)).to match_array([user_type1, user_type2])
		end
	end
end
