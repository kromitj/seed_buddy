class ARModel
	def initialize(table)
		@Model = table
		@assosiations = table.reflections.map do |ass|
		 	# puts "ar_model: #{@Model}  ass: #{ass[1].name} asstype: #{ass[1]}"
			get_assossiations(ass)
		end
		puts @assosiations
	end

	private

	def get_assossiations(ass)
		ass_type = get_ass_type(ass[1])
		{name: ass[1].name, ass_type: ass_type, model_obj: ass[1].active_record}
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