Date Start: Feb-9-2017

Members: Mitch Kroska

Repo: https://github.com/kromitj/seed_buddy 

Branch: field-relationships

##Problem/Task:
Create a data structure that reprepresents the relation ship between each DB/AR field and their cooresponding api field. The Data structure will be a hash where the key is the db field and the value is two el array where [0:field_name 1:field_path] field_path is the path to the field in the json response. Need to think about whether storing all this info in BuddyModel as opposed to in ApiModel is a good idea; when you modify the field names in ApiModel it would have to update field_relationships/

###MVP 

	On init of BuddyModel @field_relationships is created


###Nice To Haves

	Get rid of ARModel and APIModle just condence them into BuddyModel

##Main Components:
	BuddyModel#generate_field_relationships(schema)

##Idea:
	Data Structure:
	{
		ar_field_name: [api_field_name, [api_field_path]],
		"first_name": ["first_name", []]
	}

##Solutions:
	BuddyModel#initialize(model)
			@name = model.to_s
			@ar_model = ARModel.new(model)
			@api_model = APIModel.new(model, Hash[@ar_model.schema])
			@field_relationships = generate_relationships(@ar_model.schema)
	end

	BuddyModel#generate_field_relationships(schema)
		 schema.map { |field| Hash[field, [field, []]]}
	end


##Final Solution:


##End OF Day Progress Log: