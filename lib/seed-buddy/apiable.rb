class SeedBuddy
	module Apiable
		 def create_group(group_info)
		    members, api_path, api_calls = group_info[:members], group_info[:api_path], group_info[:api_calls]
		    @groups << {members: members, api_path: api_path, api_calls: []}
		 end

		 def map_group_calls(group_num, api_uri, api_key=nil, bread_crumbs_to_records=[], bread_crumbs_to_target=[], target_field)
		    json_response = HTTParty.get(api_uri)
		    reduced_hash = reduce_hash(json_response, bread_crumbs_to_records)
		    @groups[group_num][:api_calls] = reduced_hash.map { |record| reduce_hash(record, bread_crumbs_to_target)[target_field]}
		 end

		def seed_data()
		  current_group = @groups.first
		  puts current_group
		    uri_path = current_group[:api_path]
		    current_group[:api_calls].each do |call|
		      puts uri_path + call.to_s
		      # legislator_response = HTTParty.get(uri_path + call.to_s)
		      # puts legislator_response
		    end    
		 end

		def reduce_hash(hash, hash_bread_crumbs)
			return hash if hash_bread_crumbs.empty?
			key_value = hash_bread_crumbs.shift
			reduced_hash = hash[key_value]
			return reduce_hash(reduced_hash, hash_bread_crumbs)
		end
	end
end