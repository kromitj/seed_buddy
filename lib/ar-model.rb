class ARModel
	def initialize(table)
		@Model = Object.const_get(table.to_s)
		@assosiations = table.reflections.map do |ass|
			get_assossiations(ass)
		end
		@schema = Hash[*@Model.column_names.group_by { |i| i }.flat_map { |k, v| [k , nil] }] # creates a Hash repres the AR Model with initial values of zero
	end

	private

	def get_assossiations(ass)
		ass_type = get_ass_type(ass[1])
		{name: ass[1].name, ass_type: ass_type, model_obj: Object.const_get(ass[1].name.capitalize)}
	end

	def get_ass_type(ass)
		types = {
			"ActiveRecord::Reflection::BelongsToReflection" => "belongs_to",
			"ActiveRecord::Reflection::HasManyReflection" => "has_many"
		}
		types[ass.class.to_s]
	end
end



# data structure
# assossiation = {
# 	name: "person",
# 	type: "belongs_to",
# 	model_obj: Person
# }