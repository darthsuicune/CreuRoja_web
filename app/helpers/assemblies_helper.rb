module AssembliesHelper
	def assembly_levels
		[[I18n.t(:assembly_level_delegation), "delegation"], [I18n.t(:assembly_level_local), "local"], [I18n.t(:assembly_level_comarcal), "comarcal"], [I18n.t(:assembly_level_province), "provincial"], [I18n.t(:assembly_level_region), "autonomica"], [I18n.t(:assembly_level_state), "estatal"]]
	end
end
