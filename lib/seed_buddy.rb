%w(ar-model buddy-model).each do |file|
  require "seed-buddy/#{file}"
end

# Represents the wrapper class for the gem
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

  # takes in a name and returns a BuddyModel with same name
  def get_model(name)
    @Models.find do |model| 
      model.name == name
    end
  end

  # groups together models that seed from the same api call
  def create_group(group_info)
      members, api_path, api_calls = group_info[:members], group_info[:api_path], group_info[:api_calls]
      @groups << {members: members, api_path: api_path, api_calls: []}
   end

  # creates an array of values that are used make api calls to multiple resources
  # e.g [1,2,3,4,4] .../v2/person/1 .../v2/person/2
  def map_group_calls(group_num, api_uri, api_key=nil, bread_crumbs_to_records=[], bread_crumbs_to_target=[], target_field)
    json_response = Hash[HTTParty.get(api_uri)]
    reduced_hash = reduce_hash(Hash[json_response], bread_crumbs_to_records)
    @groups[group_num][:api_calls] = reduced_hash.map do |record| 
      reduce_hash(record, bread_crumbs_to_target)[target_field]
    end
  end

  # iterates through each group and iterates then iterates through each groups api_calls, 
  def seed_data()
    current_group = @groups.first
      uri_path = current_group[:api_path]
      current_group[:api_calls].each do |call|
        # legislator_response = HTTParty.get(uri_path + call.to_s)
      end    
  end

  # reduces the json response to the desired subschema
  def reduce_hash(data_hash, hash_bread_crumbs)
    return data_hash[hash_bread_crumbs.first] if hash_bread_crumbs.length == 1 # the map function destroys the breadcrumbs array
    key_value = hash_bread_crumbs.shift
    reduced_hash = data_hash.fetch(key_value)
    return reduce_hash(reduced_hash, hash_bread_crumbs)
  end

 
  # used to create a file with a json representation of SeedBuddy object. Would be used to custumize the set-up easily and 
  # visualy, then sent in as an argument
  def generate_json
    models = @Models.map { | model| model.to_json}
    json_obj = {models: models, groups: @groups}
    json_obj = JSON.pretty_generate(json_obj)
    File.open("config.rb", 'w') { |file| file.write(json_obj) }
  end

  private
  # takes out every model from Active Record that's been created for the project, rejecting 
  # models created by Active Record
  def get_ar_models
    ActiveRecord::Base.descendants.reject { |ar_model| REJECT_TABLES.include?(ar_model.name)}
  end

  # used to specify whether seeding will be done with and api or a faker,
  # going to be changed over to dependancy injection of seed_resource objects: api_resource and faker_resource
  def api_or_faker(init_param)
    if init_param == "API"
      require 'seed-buddy/api-model'
    elsif init_param == "Faker"
      require 'seed-buddy/faker-model'
    end

  end


end
