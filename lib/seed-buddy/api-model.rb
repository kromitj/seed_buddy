class SeedBuddy
	class APIModel
		attr_accessor :schema
		def initialize(model, ar_schema)
			 @model = model
			 @schema = generate_schema(ar_schema)
		end

		def modify_schema_field(mod_field)
			old_key, new_key = mod_field.first[:old_key], mod_field.first[:new_key]
			@schema[new_key] = @schema[old_key]
			@schema.delete(old_key)
		end

		def modify_schema_fields(mods)
			return true if mods.empty?
			mod_field = mods.shift
			modify_schema_field(mod_field)
			modify_schema_fields(mods)
		end

		def to_json
			{model: @model, schema: Hash[@schema.sort]}
		end

		private

		def generate_schema(schema)
			schema.each do |key, value|
			schema[key] = key.to_s
			end
		end
	end
end