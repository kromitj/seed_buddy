require 'ar-model'

class SeedBuddy
	REJECT_TABLES = ["ActiveRecord::SchemaMigration", "ActiveRecord::InternalMetadata", "ApplicationRecord"]
  def initialize()
  	Rails.application.eager_load!
  	@AR_Models = get_models.map { |ar_model| ARModel.new(ar_model)}
  end
  private

  def get_models
  	ActiveRecord::Base.descendants.reject { |ar_model| REJECT_TABLES.include?(ar_model.name)}
  end

end
