class SeedBuddy
	class APIModel
		attr_accessor :schema
		# model is an model returned by Active Record, 
		def initialize(model, ar_schema)
			 @model = model
			 @schema = generate_schema(ar_schema)
		end
		# used to differentiat the api models schema from the ar_models
		def modify_schema_field(mod_field)
			old_key, new_key = mod_field.first[:old_key], mod_field.first[:new_key]
			@schema[new_key] = @schema[old_key]
			@schema.delete(old_key)
		end

		# allows mass assignment of modifications to the schema
		def modify_schema_fields(mods)
			return true if mods.empty?
			mod_field = mods.shift
			modify_schema_field(mod_field)
			modify_schema_fields(mods)
		end

		# used to print out current state of Object, used by Parent:BuddyModel#generate_hash
		def to_json
			{model: @model, schema: Hash[@schema.sort]}
		end

		private
		# used to select included values from the json obj 
		# keys are the name of the field and the value is the path to the field
		def generate_schema(schema)
			schema.each do |key, value|
			schema[key] = key.to_s
			end
		end
	end
end