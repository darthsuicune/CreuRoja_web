require 'rails_helper'

RSpec.describe AssembliesController, :type => :controller do
	let(:admin) { FactoryGirl.create(:admin) }
	let(:user) { FactoryGirl.create(:user) }
	let(:assembly) { FactoryGirl.create(:assembly) }
	let(:location) { FactoryGirl.create(:location) }
	let(:values) { { name: "asdf", level: "level", location_id: location.id } }

	describe "without signin in" do
		describe "GET index" do
			it "redirects to login" do
				get :index
				expect(response).to redirect_to(signin_url)
			end
		end

		describe "GET new" do
			it "redirects to login" do
				get :new
				expect(response).to redirect_to(signin_url)
			end
		end

		describe "POST create" do
			it "redirects to login" do
				post :create, { assembly: values }
				expect(response).to redirect_to(signin_url)
			end
		end

		describe "GET show" do
			it "redirects to login" do
				get :show, { id: assembly.id }
				expect(response).to redirect_to(signin_url)
			end
		end

		describe "GET edit" do
			it "redirects to login" do
				get :edit, { id: assembly.id }
				expect(response).to redirect_to(signin_url)
			end
		end

		describe "PUT update" do
			it "redirects to login" do
				put :update, { id: assembly.id, assembly: values }
				expect(response).to redirect_to(signin_url)
			end
		end

		describe "DELETE destroy" do
			it "redirects to login" do
				delete :destroy, { id: assembly.id }
				expect(response).to redirect_to(signin_url)
			end
		end
	end
	describe "signed in" do
		describe "as user" do
			before {
				sign_in user
			}
			describe "GET index" do
				it "redirects to root" do
					get :index
					expect(response).to redirect_to(root_url)
				end
			end

			describe "GET new" do
				it "redirects to root" do
					get :new
					expect(response).to redirect_to(root_url)
				end
			end

			describe "GET show" do
				it "redirects to root" do
					get :show, { id: assembly.id }
					expect(response).to redirect_to(root_url)
				end
			end

			describe "GET edit" do
				it "redirects to root" do
					get :edit, { id: assembly.id }
					expect(response).to redirect_to(root_url)
				end
			end

			describe "POST create" do
				it "redirects to root" do
					post :create, { assembly: values }
					expect(response).to redirect_to(root_url)
				end
			end

			describe "PUT update" do
				it "redirects to root" do
					put :update, { id: assembly.id, assembly: values }
					expect(response).to redirect_to(root_url)
				end
			end

			describe "DELETE destroy" do
				it "redirects to root" do
					delete :destroy, { id: assembly.id }
					expect(response).to redirect_to(root_url)
				end
			end
		end
		describe "as admin" do
			before {
				sign_in admin
			}
			describe "GET index" do
				it "returns http success" do
					get :index
					expect(response).to have_http_status(:success)
				end
			end

			describe "GET new" do
				it "returns http success" do
					get :new
					expect(response).to have_http_status(:success)
				end
			end

			describe "GET show" do
				it "returns http success" do
					get :show, { id: assembly.id }
					expect(response).to have_http_status(:success)
				end
			end

			describe "GET edit" do
				it "returns http success" do
					get :edit, { id: assembly.id }
					expect(response).to have_http_status(:success)
				end
			end

			describe "POST create" do
				it "redirects" do
					post :create, { assembly: values }
					expect(response).to redirect_to(Assembly.last)
				end
			end

			describe "PUT update" do
				it "redirects" do
					@assembly = assembly
					put :update, { id: assembly.id, assembly: values }
					expect(response).to redirect_to(assembly)
				end
			end

			describe "DELETE destroy" do
				it "redirects" do
					delete :destroy, { id: assembly.id }
					expect(response).to redirect_to(assemblies_url)
				end
			end
		end
	end
end
