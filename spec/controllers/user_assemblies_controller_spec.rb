require 'rails_helper'

describe UserAssembliesController do
	let(:admin) { FactoryGirl.create(:admin) }
	let(:user) { FactoryGirl.create(:user) }
	let(:assembly) { FactoryGirl.create(:assembly) }
	let(:user_assembly) { FactoryGirl.create(:user_assembly, user_id: user.id, assembly_id: assembly.id) }

	describe "without signin in" do
		describe "POST create" do
			it "isn't allowed" do
				post :create, {}
				expect(response).to redirect_to(signin_url)
			end
		end
		describe "PUT update" do
			it "isn't allowed" do
				put :update, {id: user_assembly.id}
				expect(response).to redirect_to(signin_url)
			end
		end
		describe "DELETE destroy" do
			it "isn't allowed" do
				delete :destroy, {id: user_assembly.id}
				expect(response).to redirect_to(signin_url)
			end
		end
	end
	describe "signed in" do
		describe "as admin" do
			before {
				sign_in admin
			}
			describe "POST create" do
				it "is allowed" do
					post :create, { user_assembly: { user_id: user.id, assembly_id: assembly.id } }
					expect(response).to redirect_to(user)
				end
				it "doesn't allow duplicates" do
					expect {
						post :create, { user_assembly: { user_id: -7, assembly_id: assembly.id } }
					}.to raise_error(ActionController::ActionControllerError)
				end
			end
			describe "PUT update" do
				it "is allowed" do
					put :update, {id: user_assembly.id, user_assembly: { user_id: user.id, assembly_id: assembly.id } }
					expect(response).to redirect_to(user)
				end
			end
			describe "DELETE destroy" do
				it "is allowed" do
					delete :destroy, {id: user_assembly.id}
					expect(response).to redirect_to(user)
				end
			end
		end
		describe "as user" do
			before {
				sign_in user
			}
			describe "POST create" do
				it "redirects to root" do
					post :create, {}
					expect(response).to redirect_to(root_url)
				end
			end
			describe "PUT update" do
				it "redirects to root" do
					put :update, {id: user_assembly.id}
					expect(response).to redirect_to(root_url)
				end
			end
			describe "DELETE destroy" do
				it "redirects to root" do
					delete :destroy, {id: user_assembly.id}
					expect(response).to redirect_to(root_url)
				end
			end
		end
	end
end
