Date Start: Feb-8-2017

Members: Mitch Kroska

Repo: https://github.com/kromitj/seed_buddy 

Branch: seed_func

##Problem/Task:

Seeding the models inside SeedBuddy instance

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

	  def seed_data()
      current_group = @groups.first
        uri_path = current_group[:api_path]
        current_group[:api_calls].each do |call|
          # legislator_response = HTTParty.get(uri_path + call.to_s)
        end    
     end

	SeedBuddy@models#Array[#BuddyModel]: compared against each other to determe dependancy

	Components that need to be made:
		BuddyModel#Dependancies -> Array[dep_model_name]


##Idea:
*	method will seed A.R. models in the order that they where specified in SeedBuddy#create_group(group_info)

*	before Model.create(record_data) check BuddyModel#dependancies and iterate through dependancies, creating an instance of each
	then pushing them in the record_creation hash

##Solutions:

##Final Solution:



