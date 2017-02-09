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
	SeedBuddy@models: compared against each other to determe dependancy

##Ideas:


##Solutions:

##Final Solution:



