class BuddyModel
	attr_reader :ar_model
	def initialize(model)
		@uri = nil
		@ar_model = ARModel.new(model)
		@api_model = APIModel.new(model, @ar_model.schema)
		@groups = []
	end

	def create_group(members, api_call)
		@groups << {members: members, api_call: api_call}
	end

	def self.map_api_call(api_uri, json_nav, target_field)
		api_call_uri = "https://www.govtrack.us/api/v2/person/#{legislator_id}"
		HTTParty.get(api_call_uri)
	end
end