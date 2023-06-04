//
//  APIURL.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import Foundation

import Foundation

enum APIURL {
    case mealsList
    case mealDetails(mealID: String)
    
    private var url: String {
        switch self {
        case .mealsList:
            return "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert"
        case .mealDetails(let mealID):
            return "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        }
    }
    
    var createURLRequest: URLRequest {
        .init(url: URL(string: url)!)
    }
}
