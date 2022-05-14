//
//  Contants.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation
struct ApiEndPoints{
    private let baseURL = "https://foodplanbasket.com/laraveladminbackend/api/"
    static let login = "\(ApiEndPoints().baseURL)login"
    static let createAccount = "\(ApiEndPoints().baseURL)register"
    static let fetchAllRecipes = "\(ApiEndPoints().baseURL)customer/recipes"
    
    static let customerSelectRecipes = "\(ApiEndPoints().baseURL)customer/customer-recipes"
    
    static let addRecentRecipe = "\(ApiEndPoints().baseURL)customer/recent-recipe-add"
    
    static let addFavouriteRecipe = "\(ApiEndPoints().baseURL)customer/favourite-add"
    
    static let customerAllRecentRecipe = "\(ApiEndPoints().baseURL)customer/recent-recipe"
    
    static let customerFavouriteRecipesView = "\(ApiEndPoints().baseURL)customer/favourite-view"
    static let distance = "\(ApiEndPoints().baseURL)customer/distance"
    static let checkout = "\(ApiEndPoints().baseURL)customer/checkout"
    static let placeOrder = "\(ApiEndPoints().baseURL)customer/order_create"
    static let searchRecipes = "\(ApiEndPoints().baseURL)customer/search_recipes"
}

struct StringKeys{
    static let saveUserKey = "user"
    static let authError = "AuthError"
}
