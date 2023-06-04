//
//  MealsModel.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import Foundation


struct MealsModel: Codable {
    var meals: [Meal]?
}

struct Meal: Identifiable, Codable {
    var id: String?
    var name: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case icon = "strMealThumb"
    }
}

struct MealDetails: Codable {
    var meals: [[String: String?]]
}
