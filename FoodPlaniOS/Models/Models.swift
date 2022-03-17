//
//  Models.swift
//  FoodPlaniOS
//
//  Created by Muhammad Ali on 17/03/2022.
//

import Foundation
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

    enum CodingKeys: String, CodingKey {
        case id, name, category, servings
        case cookingTime = "cooking_time"
        case imageURL = "imageUrl"
        case videoTitle = "video_title"
        case videoURL = "video_url"
        case videoDescription = "video_description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
