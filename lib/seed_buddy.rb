require 'ar-model'

class SeedBuddy
	REJECT_TABLES = ["ActiveRecord::SchemaMigration", "ActiveRecord::InternalMetadata", "ApplicationRecord"]
  def initialize(api_uri)
  	Rails.application.eager_load!
  	@api = api_uri
  	@AR_Models = get_ar_models.map { |ar_model| ARModel.new(ar_model)}
  	@APIModels = nil
  end

  def self.map_api_call(api_uri, api_key=nil, bread_crumbs_to_records=[], bread_crumbs_to_target=[], target_field) # json_nav = ["person", "role"]
    json_response = HTTParty.get(api_uri)
    reduced_hash = reduce_hash(json_response, bread_crumbs_to_records)
    reduced_hash.map { |record| reduce_hash(record, bread_crumbs_to_target)[target_field]}
  end

  private

  def get_ar_models
  	ActiveRecord::Base.descendants.reject { |ar_model| REJECT_TABLES.include?(ar_model.name)}
  end

  def self.reduce_hash(hash, hash_bread_crumbs)
    return hash if hash_bread_crumbs.empty?
    key_value = hash_bread_crumbs.shift
    reduced_hash = hash[key_value]
    return reduce_hash(reduced_hash, hash_bread_crumbs)
  end

end
