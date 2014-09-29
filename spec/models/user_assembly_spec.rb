require 'rails_helper'

describe UserAssembly do
	let(:user) { FactoryGirl.create(:user) }
	let(:assembly) { FactoryGirl.create(:assembly) }
	let(:user_assembly) { FactoryGirl.create(:user_assembly, assembly_id: assembly.id, user_id: user.id) }

	subject { user_assembly }
	
	it { should respond_to(:user) }
	it { should respond_to(:assembly) }
end
