class SeedBuddy
	class BuddyModel		
		attr_reader :ar_model, :name
		attr_accessor :api_model
		def initialize(model)
			@name = model.to_s
			@ar_model = ARModel.new(model)
			@api_model = APIModel.new(model, Hash[@ar_model.schema])
		end


		def to_json
			{name: @name, ar_model: @ar_model.to_json, api_model: @api_model.to_json}
		end
		

		def show_schema(api_or_ar)
			if api_or_ar == "api"
				"#{@name} Api Model: #{@api_model.schema}"
			elsif api_or_ar == "ar"
				"#{@name} AR Model: #{@ar_model.schema}"
			else
				puts "show_schema arg requires a String with a value of either 'api' or 'ar'"
			end
		end

		def compare_schemas
			api_sort = @api_model.schema.sort
			ar_sort = @ar_model.schema.sort
			longest = find_longest_field + 5
			spaces = " "*(longest-10)
			puts "API Schema#{spaces}| AR Schema"
			puts '__________________________'
			api_sort.each_with_index do |field, i|
				spaces = " "*(longest - field[0].length)
				puts "#{field[0]}#{spaces}| #{ar_sort[i][0]}"
			end
		end


		private 

		def find_longest_field
			current_longest = nil
			@api_model.schema.each do |field|
				if current_longest == nil || field[0].length > current_longest
					current_longest = field[0].length
				end
			end
			return current_longest
		end


	end
end