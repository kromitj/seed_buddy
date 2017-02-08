%w(ar-model buddy-model).each do |file|
  require "seed-buddy/#{file}"
end

class SeedBuddy
  attr_accessor :Models, :groups
	REJECT_TABLES = ["ActiveRecord::SchemaMigration", "ActiveRecord::InternalMetadata", "ApplicationRecord"]
  def initialize(api_faker, uri_prefix)
    api_or_faker(api_faker)
  	Rails.application.eager_load!
    @uri_prefix = uri_prefix
  	@Models = get_ar_models.map { |ar_model| BuddyModel.new(ar_model) }
    @groups = []
    generate_json
  end

  def get_model(name)
    @Models.find do |model| 
      model.name == name

    end
  end

  def create_group(group_info)
        members, api_path, api_calls = group_info[:members], group_info[:api_path], group_info[:api_calls]
        @groups << {members: members, api_path: api_path, api_calls: []}
     end

     def map_group_calls(group_num, api_uri, api_key=nil, bread_crumbs_to_records=[], bread_crumbs_to_target=[], target_field)
        json_response = Hash[HTTParty.get(api_uri)]
        reduced_hash = reduce_hash(Hash[json_response], bread_crumbs_to_records)
        @groups[group_num][:api_calls] = reduced_hash.map do |record| 
          reduce_hash(record, bread_crumbs_to_target)[target_field]
        end
     end

    def seed_data()
      current_group = @groups.first
        uri_path = current_group[:api_path]
        current_group[:api_calls].each do |call|
          # legislator_response = HTTParty.get(uri_path + call.to_s)
        end    
     end

    def reduce_hash(data_hash, hash_bread_crumbs)
      return data_hash[hash_bread_crumbs.first] if hash_bread_crumbs.length == 1 # the map function destroys the breadcrumbs array
      key_value = hash_bread_crumbs.shift
      reduced_hash = data_hash.fetch(key_value)
      return reduce_hash(reduced_hash, hash_bread_crumbs)
    end

 

  def generate_json
    models = @Models.map { | model| model.to_json}
    json_obj = {models: models, groups: @groups}
    json_obj = JSON.pretty_generate(json_obj)
    File.open("config.rb", 'w') { |file| file.write(json_obj) }
  end

  private

  def get_ar_models
    ActiveRecord::Base.descendants.reject { |ar_model| REJECT_TABLES.include?(ar_model.name)}
  end

  def api_or_faker(init_param)
    if init_param == "API"
      require 'seed-buddy/api-model'
    elsif init_param == "Faker"
      require 'seed-buddy/faker-model'
    end

  end


end
