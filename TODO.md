#TODOS:

		
*	()	Create MVP of SeedBuddy#seed

*	() Create Seed Order method(looks at assossiates and generates an order)*
*	(√) Have schemas be generated in alphabetical order
* 	() Add ability to config SeedBuddy object with outputed config.rb file

*	(√) Fix SeedBuddy#reduce_hash, its not returning the correct id from the json response

		! solution isn't optimal... isn't recursive, need to figure out how to feed the same bread-crump array through each iteration of the map function; the bread-crumb array with destroyed during the first iteration. 
		* 	() Figure out how to not have the SeedBuddy#reduce_hash destroy its bread_crump arg on its first time through the map func