Date Start: Feb-9-2017

Members: Mitch Kroska

Repo: https://github.com/kromitj/seed_buddy 

Branch: model-depend

Status: In Design

##Problem/Task:
When seeding an Active Record model its dependencies need to created and stuffed into the creation hash before the current model
record is created.

###MVP 
    Create dependencies, push them into creation hash

###Nice To Haves
    Recursive dependancy if a models dependancy has a deendancy, there needs to be a way for that to work

##Main Components:
    ARModel#dependencies -> []

##Idea:

##Solutions:


##Final Solution:


##End OF Day Progress Log: