json.array!(@assemblies) do |assembly|
	json.extract! assembly, :id, :name, :description, :level, :address, :phone
	json.url assembly_url(assembly, format: :json)
end
