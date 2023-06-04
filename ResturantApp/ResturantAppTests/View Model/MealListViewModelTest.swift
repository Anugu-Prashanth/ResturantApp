//
//  MealListViewModelTest.swift
//  ResturantAppTests
//
//  Created by Anugu Prashanth on 6/4/23.
//

import XCTest
@testable import ResturantApp

class MealListViewModelTests: BaseTest {
    var viewModel: MealListViewModel!
    var mockRestClientService: MockRestClientService!
    
    override func setUp() {
        super.setUp()
        mockRestClientService = MockRestClientService()
        viewModel = MealListViewModel()
        viewModel.restClientService = mockRestClientService
    }
    
    override func tearDown() {
        mockRestClientService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testRefreshMealList_Success() {
        let sampleData = """
        {
            "meals": [
                {
                    "strMeal": "Pasta",
                    "strMealThumb": "https://www.example.com/pasta.jpg",
                    "idMeal": "1"
                },
                {
                    "strMeal": "Pizza",
                    "strMealThumb": "https://www.example.com/pizza.jpg",
                    "idMeal": "2"
                }
            ]
        }
        """.data(using: .utf8)
        
        mockRestClientService.data = sampleData
        mockRestClientService.error = nil
        
        
        viewModel.refreshMealList { result in
            // Assert
            switch result {
            case .success(let meals):
                XCTAssertEqual(meals.count, 2)
                
                XCTAssertEqual(meals[0].id, "1")
                XCTAssertEqual(meals[0].name, "Pasta")
                XCTAssertEqual(meals[0].icon, "https://www.example.com/pasta.jpg")
                
                XCTAssertEqual(meals[1].id, "2")
                XCTAssertEqual(meals[1].name, "Pizza")
                XCTAssertEqual(meals[1].icon, "https://www.example.com/pizza.jpg")
                
            case .failure(let error):
                XCTFail("Expected success, but received failure: \(error)")
            }
            
        }
        
    }
    
    func testRefreshMealList_Failure() {
        // Arrange
        let expectedError = NSError(domain: "TestErrorDomain", code: 401, userInfo: nil)
        
        mockRestClientService.data = nil
        mockRestClientService.error = expectedError
        
        
        viewModel.refreshMealList { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Expected failure, but received success")
            case .failure(let error):
                XCTAssertEqual(error as! AppError, AppError.serverError(expectedError.localizedDescription))
            }
            
        }
        
    }
}

class MockRestClientService: RestClientService {
    var data: Data?
    var error: Error?
    
    override func getData(urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> ()) {
        completionHandler(data, error)
    }
}
