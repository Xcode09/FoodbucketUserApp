//
//  Contants.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation
struct ApiEndPoints{
    private let baseURL = "https://foodplanbasket.com/laraveladminbackend/api/"
    static let fetchAllRecipes = "\(ApiEndPoints().baseURL)customer/recipes"
    
    static let customerSelectRecipes = "\(ApiEndPoints().baseURL)customer/customer-recipes"
    
    static let addRecentRecipe = "\(ApiEndPoints().baseURL)customer/recent-recipe-add"
    
    static let customerAllRecentRecipe = "\(ApiEndPoints().baseURL)customer/recent-recipe"
    
    static let customerFavouriteRecipesView = "\(ApiEndPoints().baseURL)customer/favourite-view"
}
