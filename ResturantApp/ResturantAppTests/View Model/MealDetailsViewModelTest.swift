//
//  MealDetailsViewModelTest.swift
//  ResturantAppTests
//
//  Created by Anugu Prashanth on 6/4/23.
//

import XCTest
@testable import ResturantApp

class MealDetailsViewModelTests: BaseTest {
    var viewModel: MealDetailsViewModel!
    var mockRestClientService: MockRestClientService!
    override func setUp() {
        super.setUp()
        mockRestClientService = MockRestClientService()
        viewModel = MealDetailsViewModel()
        viewModel.restClientService = mockRestClientService
    }
    
    override func tearDown() {
        mockRestClientService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchMealDetails_Success() {
        let mealID = "123"
        let sampleData = """
    {
        "meals": [
            {
                "strIngredient1": "Ingredient 1",
                "strIngredient2": "Ingredient 2",
                "strIngredient3": "Ingredient 3"
            }
        ]
    }
    """.data(using: .utf8)
        
        mockRestClientService.data = sampleData
        mockRestClientService.error = nil
        
        viewModel.fetchMealDetails(mealID: mealID) { result in
            // Assert
            switch result {
            case .success(let meals):
                XCTAssertEqual(meals.count, 3)
                XCTAssertEqual(meals["strIngredient1"], "Ingredient 1")
                XCTAssertEqual(meals["strIngredient2"], "Ingredient 2")
                XCTAssertEqual(meals["strIngredient3"], "Ingredient 3")
            case .failure(let error):
                XCTFail("Expected success, but received failure: \(error)")
            }
            
        }
        
    }
    
    func testFetchMealDetails_Failure() {
        let mealID = "123"
        let expectedError = NSError(domain: "TestErrorDomain", code: 401, userInfo: nil)
        
        mockRestClientService.data = nil
        mockRestClientService.error = expectedError
        
        viewModel.fetchMealDetails(mealID: mealID) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but received success")
            case .failure(let error):
                XCTAssertEqual(error as! AppError, AppError.serverError("serverError"))
            }
            
        }
        
    }
}
