﻿#Provides the method Insert(recipe_id, ingredients, portion)
#that inserts all ingredients in the array of strings ingredients. 
#portion is used to divide the ingredient to fit portion size 1
#recipe_id is the id of the recipe containing the ingredient in the database table foodl.recipes

class IngredientInserter
	def self.Insert(recipe_id, ingredients, portion)
		ingredients.each do |s|
			IngredientComponent.Analyze(s, portion) #extracts information from the ingredient and scales to portion size 1
			food_name = IngredientComponent.GetName()
			map_result = IngredientMapper.Map(food_name) #maps the ingredient to the best matching food_type in db. Returns [food_type_id, match_percent]
			food_type_id = map_result[0]
			match = map_result[1]
			q = "INSERT INTO  `foodl`.`ingredients` (
	`quantity` ,
	`unit` ,
	`food_type_id` ,
	`recipe_id` ,
	`created_at` ,
	`updated_at` ,
	`name`,
	`match`,
	`original`
	)
	VALUES (
	'"+IngredientComponent.GetAmount().to_s+"' , 
	'"+IngredientComponent.GetUnit()+"' , 
	'"+food_type_id+"',
	'"+recipe_id.to_s+"', 
	now(),
	now(),
	'"+DB.Get.escape_string(IngredientComponent.GetName()).force_encoding("UTF-8")+"',
	'"+match.to_s+"',
	'"+@@db.escape_string(IngredientComponent.GetOriginalName()).force_encoding("UTF-8")+"'
	)"
	DB.Get.query(q)
		end
	end
end #end of class



