//
//  ShopListModel.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 28/04/2022.
//

import Foundation
struct ShopListModel: Codable {
    let id, recipeID, ingredientID, quantity: String?
    let unit, createdAt, updatedAt, shopID: String?
    let ingreID, name, totalQuantity, brandName: String?
    let points, amount: String?
    let imageURL: String?
    let roleID, address: String?
    let latitude, longitude: String?
    let email, password: String?
    let distance:String?

    enum CodingKeys: String, CodingKey {
        case id
        case recipeID = "recipe_id"
        case ingredientID = "ingredient_id"
        case quantity, unit
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case shopID = "shop_id"
        case ingreID = "ingre_id"
        case name
        case totalQuantity = "total_quantity"
        case brandName = "brand_name"
        case points, amount
        case imageURL = "imageUrl"
        case roleID = "role_id"
        case address, latitude, longitude, email, password,distance
    }
}
