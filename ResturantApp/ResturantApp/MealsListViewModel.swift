//
//  MealsListViewModel.swift
//  ResturantApp
//
//  Created by Anugu Prashanth on 6/4/23.
//

import Foundation

class MealListViewModel {
    lazy var restClientService = RestClientService()
    
    func refreshMealList(onCompletion: @escaping (Result<[Meal], Error>) -> ()) {
        restClientService.getData(urlRequest: APIURL.mealsList.createURLRequest) { data, error in
            guard let data = data,
                    let mealsModel = try? JSONDecoder().decode(MealsModel.self, from: data) else {
                return onCompletion(.failure(AppError.serverError(error?.localizedDescription ?? "Failed To Load Data")))
            }
            
            onCompletion(.success(mealsModel.meals ?? []))
        }
    }
}

enum AppError: Error, Equatable{
    case serverError(_ errorString: String)
}
