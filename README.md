# seed_buddy

##Uses Active Record Models to automate alot of the steps needed to seed a database using either api calls or faker data


Example Usage

		Author has_many: posts
			    belongs_to: :blog
		Post belongs_to :blog


		seeder = SeedBuddy.new("api", "http://www.blogworld.com/api/v12/")
		seeder.map_group_calls(0, "http://www.blogworld.com/api/v12/author?type=political", nil, ["authors"], [], "name")
		seeder.create_group({members: ["Author", "Post"], api_path: "http://www.blogworld.com/api/v12/author/"})
		seeder.seed


http://www.blogworld.com/api/v12/author?type=political
returns this:

		{
			"authors": [
				{
				"name": "dimitri",
				
				},
				{
				"name": "carl",
				
				},

			]
		}

http://www.blogworld.com/api/v12/author/dimitri
returns this:

		{	
			[
				{
				"title": "Cats aren't cool",
				"body": "I just think that...."
				},
				{
				"title": "Racecars are fast",
				"body": "I just like the way they sound when they pass you..."
				},
				{
				"title": "Cats are cool",
				"body": "I just think that...."
				},
				{
				"title": "Racecars aren't fast",
				"body": "I just like the way they sound when they pass you..."
				},
			]
		}

