//
//  MealDetailsViewModel.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import Foundation

class MealDetailsViewModel {
    //create Protocol and point the below property to mock for unit testing
    lazy var restClientService = RestClientService()
    
    func fetchMealDetails(mealID: String, onCompletion: @escaping (Result<[String: String?], Error>) -> ()) {
        restClientService.getData(urlRequest: APIURL.mealDetails(mealID: mealID).createURLRequest) { data, error in
            
            guard let data = data else {
                return onCompletion(.failure(AppError.serverError("serverError")))
            }
            do {
                let details = try JSONDecoder().decode(MealDetails.self, from: data)
                var meals = details.meals[0]
                
                //trimming nil and empty values..
                meals = meals.filter({ $0.value != nil })
                meals = meals.filter({ ($0.value ?? "").trimmingCharacters(in: .whitespaces).isEmpty == false })
                
                onCompletion(.success(meals))
            } catch(let error) {
                print("error: \(error)")
            }
            print("fetched meal details")
        }
    }
}
