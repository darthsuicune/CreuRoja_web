require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AssembliesHelper. For example:
#
# describe AssembliesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AssembliesHelper, :type => :helper do
	describe "assembly_levels" do
		it "should return a list with the levels and their translations for easy use in selects" do
			expect(assembly_levels).to eq [[I18n.t(:assembly_level_delegation), "delegation"], [I18n.t(:assembly_level_local), "local"], [I18n.t(:assembly_level_comarcal), "comarcal"], [I18n.t(:assembly_level_province), "provincial"], [I18n.t(:assembly_level_region), "autonomica"], [I18n.t(:assembly_level_state), "estatal"]]
		end
	end
end
