﻿#Provides methods 
#	Map(str) that maps a str into the closest ingredient
#	Test() that allows a user for testing the map of different input strings

class IngredientInserter

require "mysql"

@@foods = [] #contains elements from database table food_types [name, id]
@@warn_below = 10

@@db = Mysql.init
@@db.options(Mysql::SET_CHARSET_NAME, 'utf8')
@@db.real_connect('198.175.125.69', 'foodl', 'foodl4321', 'foodl')
@@db.query("SET NAMES utf8")


def self.load_food_from_db
	res = @@db.query("select `name`, `id` from `foodl`.`food_types`")
	res.each do |row|
		@@foods << [row[0].force_encoding("UTF-8"), row[1]]
	end
end

def self.find_longest_common_string(str1, str2)
	lc = ""
	for start in 0...str1.length - lc.length do
		for length in lc.length + 1..str1.length - start do
		  find = str1[start,length]
		  if (str2.include? find)
			lc = find
		  end
		end
	end
	return lc;
end
  
def self.remove_first_on_text(text, remove) 
	for i in 0..text.length - remove.length do
		if (text[i, remove.length] == remove) 
		  return text[0,i] + text[i+remove.length,text.length-(i+remove.length)]
		end
	end
	return text
end

def self.find_text_match(txt1, txt2)
	txt1 = txt1.downcase
	txt2 = txt2.downcase
	maxStartSize = [txt1.length, txt2.length].max
	if (maxStartSize == 0) #if both string are empty
		return 1
	end
	score = 1
	while (lc = find_longest_common_string(txt1, txt2)) != "" do
		txt1 = remove_first_on_text(txt1, lc)
		txt2 = remove_first_on_text(txt2, lc)
		score += lc.length * lc.length
		score -= 1
	end
	match = score * 100 / (maxStartSize * maxStartSize)
	return match
end

def self.test()
	input1 = "agurk"
	input2 = "gakurk"
	while input1 != "" || input2 != "" do
		puts "Indtast ingrediens 1: "
		input1 = gets.chomp
		puts "Indtast ingrediens 2: "
		input2 = gets.chomp
		puts find_text_match(input1, input2)
	end
end

def self.print_food_table()
	@@foods.each do |s|
		puts s[0].force_encoding("UTF-8") +" : " + s[1].to_s   #outputs name : id
	end
end

def self.map_ingredient(str) #returns the id of the best matching food type	
	best_match = 0
	best_id = 0
	best_name = "error"
	@@foods.each do |s|
		name = s[0]
		id = s[1]
		match = find_text_match(str, name)
		if (match > best_match)
			best_match = match
			best_id = id
			best_name = name
		end
	end
	if (best_match < @@warn_below)
		puts "Warning: low match ("+best_match.to_s+") between: '"+str+"' and '"+ best_name +"'"
	end
	return best_id
end

def self.Insert(recipe_id, ingredients, portion)
	ingredients.each do |s|
		IngredientComponent.Analyze(s, portion) #extracts information from the ingredient and scales to portion size 1
		food_name = IngredientComponent.GetFoodName()
		food_type_id = map_ingredient(food_name) #maps the ingredient to the best matching food_type in db
		q = "INSERT INTO  `foodl`.`ingredients` (
`id` ,
`quantity` ,
`unit` ,
`food_type_id` ,
`recipe_id` ,
`created_at` ,
`updated_at` ,
`name`
)
VALUES (
NULL , 
'"+IngredientComponent.GetAmount().to_s+"' , 
'"+IngredientComponent.GetUnit()+"' , 
'"+food_type_id+"',
'"+recipe_id.to_s+"', 
now(),
now(),
'"+IngredientComponent.GetOriginal()+"'
)"
@@db.query(q)
	end
end

load_food_from_db()
#map_ingredient("Simon")
#print_food_table()
#test()

end #end of class


