Date Start: Feb-8-2017

Members: Mitch Kroska

Repo: https://github.com/kromitj/seed_buddy 

Branch: seed_func

##Problem/Task:

Seeding the models inside SeedBuddy instance

Need to match the ar_model fields with the api_model fields

Example Sitch:
Person has_many: :roles, :committe_members
Roles belongs_to: :person
CommitteMember belongs_to :person

when seeding a role you would first need to due this:
person = Person.find_by(id: id)
new_role[:person_id] = person
Role.create(new_role)


###MVP 

Need to be able to take the BuddyModels initiated inside SeedBuddy and use there properties to seed a database using an API call



###Nice To Haves
 Seed Order is decided based on associations of Models 	



##Main Components:
	SeedBuddy#seed: will be called from inside db/seeds.rb


	SeedBuddy@models#Array[#BuddyModel]: compared against each other to determe dependency

	Components that need to be made:
		SeedBuddy#makeApiCall(group_info) -> Hash  json response
		SeedBuddy#seedGroup(group) -> Boolean was_successful?
		SeedBuddy#make_api_calls(group) -> Boolean was_successful?
		BuddyModel#seed -> Boolean was_successful?
		BuddyModel#dependencies -> Array[dep_model_name]
		BuddyModel#match_fields -> Hash {ar_field: api_field} # example {"committee_id": "committee"}


##Idea:
*	method will seed A.R. models in the order that they where specified in SeedBuddy#create_group(group_info)

*	before Model.create(record_data) check BuddyModel#dependencies and iterate through dependencies, creating an instance of each
	then pushing them in the record_creation hash

##Solutions:

	####SudoCode:

	  ->SeedBuddy#seed is called
	  	->SeedBuddy looks at @groups[[]] and iterates through each sub array group
  			->Iterate over the current groups[:api_calls]#Array 
  				->SeedBuddy#make_api_call(group_info) uses current api_call from api_calls and returns the expected record
		  		->Seed based on the order of the model elements inside the array 
		  			->BuddyModel#dependencies is called and returns the current models dependancies
		  				-> BuddyModel#match_fields takes the field relationships between ar_model and api to take the api responce 	and	create a hash that matches the Active Record schema fields
		  				->dependancies are retrieved from Active record and push inside the hash that will create the new record

	real code: 	  			

	  SeedBuddy#seed_data
	      @groups.each do |group| 
	      	seed_group(group)
	      end   
     end

     SeedBuddy#seed_group(group)
     	make_api_calls(group)
     end

     SeedBuddy#make_api_calls(group)
     	api_calls = group[:api_calls]
     	api_calls.each do |api_call|
	     	api_response = HTTParty.get(uri_path + call.to_s)
	     	group.each do |member|
	     		seed_member(member, response)
	     	end       		
     	end
     end

     SeedBuddy#seed_member(member, response)
     	dependencies = member.create_dependencies(response) # {model: Person foreign_key: person_id}
     	seed_hash = {}
     	@match_field.each do |ar_field, api_field| 
     		seed_hash[ar_field] = response[api_field]
     	end
     	dependencies.each { |dependency| seed_hash[dependency[:foreign_key]] = dependency[:model]}
     	member.create(seed_hash)
     end

     BuddyModel#dependencies

     end

     BuddyModel#create_dependencies(response)
     	dependencies = self.dependencies # {model: Person, find_by: :id}}
     	 model_dependencies = dependencies[:model].map do |dependency|
     		api_find_by = @match_fields(dependency[:find_by])  # match_fields needs to be a hash with key:ar_field:  value:api_field
     		find_by_value = responce[api_find_by]
     		dependency[:model].find_by(depencency[:find_by] => find_by_value)
     	end
     end

     BuddyModel#dependency()

     end
	
		BuddyModel#dependencies -> Array[dep_model_name]
		SeedBuddy#makeApiCall(group_info) -> Hash  json response
		BuddyModel#match_fields -> Hash {ar_field: api_field} # example {"committee_id": "committee"}

##Final Solution:



