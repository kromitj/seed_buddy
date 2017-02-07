class BuddyModel
	def initialize(model)
		@ar_model = ARMODEL.new(model)
		@api_model = APIModel.new(model)
	end
end
x