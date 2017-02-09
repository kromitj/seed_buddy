class SeedBuddy
	# a class that encapsolates an Active Record Model object
	class ARModel
		attr_reader :schema
		def initialize(table)
			@Model = Object.const_get(table.to_s)
			# creates assossiates from the AR Model
			@assosiations = table.reflections.map do |ass|
				get_assossiations(ass)
			end
			@schema = Hash[*@Model.column_names.group_by { |i| i }.flat_map { |k, v| [k , ""] }] # creates a Hash repres the AR Model with initial values of zero
		end
		# used to print out current state of Object, used by Parent:BuddyModel#generate_hash
		def to_json
			{modle: @Model, associations: @assosiations, schema: Hash[@schema.sort]}
		end

		private
		# takes each association of the AR object and pushes it into @associations 
		def get_assossiations(ass)
			ass_type = get_ass_type(ass[1])
			singular_upcased_model_name =  ActiveSupport::Inflector.singularize(ass[1].name).camelize  
			{name: ass[1].name, ass_type: ass_type, model_obj: Object.const_get(singular_upcased_model_name)}
		end

		# takes in AR Obj andreturns either belongs_to or has_many 
		def get_ass_type(ass)
			types = {
				"ActiveRecord::Reflection::BelongsToReflection" => "belongs_to",
				"ActiveRecord::Reflection::HasManyReflection" => "has_many"
			}
			types[ass.class.to_s]
		end
	end
end



	# data structure
	# assossiation = {
	# 	name: "person",
	# 	type: "belongs_to",
	# 	model_obj: Person
	# }