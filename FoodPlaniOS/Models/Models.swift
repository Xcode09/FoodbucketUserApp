//
//  Models.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation

struct BasicModel:Codable{
    let message:String
}

struct LoginDataModel: Codable {
    let user: User?
    let accessToken: String?
    
    enum CodingKeys: String, CodingKey {
        case user
        case accessToken = "access_token"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let name, imageURL, roleID, address: String?
    let latitude, longitude: String?
    let email, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "imageUrl"
        case roleID = "role_id"
        case address, latitude, longitude, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct RecipesModel: Codable {
    let message: String?
    let data: [Recipes]?
}


// MARK: - Datum
struct Recipes: Codable,Identifiable{
    let id: Int?
    let name, category, servings, cookingTime: String?
    let imageURL: String?
    let videoTitle: String?
    let videoURL: String?
    let videoDescription: String?
    let createdAt, updatedAt: String?
    let proteins:String?
    let calories:String?
    let fats:String?
    let carbohydrates:String?
    let stepRecipe: [StepRecipe]?
    let ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, servings
        case cookingTime = "cooking_time"
        case imageURL = "imageUrl"
        case videoTitle = "video_title"
        case videoURL = "video_url"
        case videoDescription = "video_description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case stepRecipe = "step_recipe"
        case ingredients
        case proteins,fats,calories,carbohydrates
    }
}
struct Ingredient: Codable,Identifiable{
    let id: Int?
    let recipeID, ingredientID, quantity, createdAt: String?
    let updatedAt: String?
    let ingredientName: [IngredientName]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case recipeID = "recipe_id"
        case ingredientID = "ingredient_id"
        case quantity
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ingredientName = "ingredient_name"
    }
}
struct IngredientName: Codable,Identifiable{
    let id: Int?
    let ingreID:String?
    let shopID, name, totalQuantity, unit: String?
    let brandName: String?
    let imageURL: String?
    let createdAt, updatedAt: String?
    let amount:String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shopID = "shop_id"
        case name
        case totalQuantity = "total_quantity"
        case unit
        case brandName = "brand_name"
        case imageURL = "imageUrl"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ingreID = "ingre_id"
        case amount
        
    }
}

struct StepRecipe: Codable,Identifiable{
    let id: Int?
    let recipeID, noOfStep, title, imageURL: String?
    let stepRecipeDescription, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case recipeID = "recipe_id"
        case noOfStep = "no_of_step"
        case title
        case imageURL = "imageUrl"
        case stepRecipeDescription = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK:- Favourite Receipe Model

struct FavouriteReceipeDataModel: Codable {
    let message: String?
    let data: [FavouriteReceipeModel]?
}

struct FavouriteReceipeModel: Codable {
    let id: Int?
    let recipeID, userID, createdAt, updatedAt: String?
    let recipe: Recipe?
    
    enum CodingKeys: String, CodingKey {
        case id
        case recipeID = "recipe_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case recipe
    }
}
struct Recipe: Codable,Identifiable{
    let id: Int?
    let name, category, servings, cookingTime: String?
    let imageURL: String?
    let videoTitle: String?
    let videoURL: String?
    let videoDescription: String?
    let createdAt, updatedAt: String?
    let stepRecipe: [StepRecipe]?
    let ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, servings
        case cookingTime = "cooking_time"
        case imageURL = "imageUrl"
        case videoTitle = "video_title"
        case videoURL = "video_url"
        case videoDescription = "video_description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case stepRecipe = "step_recipe"
        case ingredients
    }
}
