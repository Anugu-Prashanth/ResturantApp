//
//  RestClientServiceTest.swift
//  ResturantAppTests
//
//  Created by Anugu Prashanth on 6/4/23.
//


import XCTest
@testable import ResturantApp

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, response, error)
        return URLSession.shared.dataTask(with: request)
    }
}

class RestClientServiceTests: BaseTest {
    var service: RestClientService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        service = RestClientService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        mockURLSession = nil
        service = nil
        super.tearDown()
    }
    
    func testGetData_WithData_Success() {
        let sampleData = """
        {
            "meals": [
                {
                    "strMeal": "Apam balik",
                    "strMealThumb": "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg",
                    "idMeal": "53049"
                }
            ]
        }
        """.data(using: .utf8)
        
        let expectedData = sampleData
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let mockError: Error? = nil
        mockURLSession.data = expectedData
        mockURLSession.response = response
        mockURLSession.error = mockError
        
        
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        
        service.getData(urlRequest: request) { (data, error) in
            // Assert
            XCTAssertEqual(data, expectedData)
            XCTAssertNil(error)
        }
        
    }
    
    
    func testGetData_WithError_Failure() {
        let expectedError = NSError(domain: "TestErrorDomain", code: 123, userInfo: nil)
        let mockData: Data? = nil
        let response: URLResponse? = nil
        mockURLSession.data = mockData
        mockURLSession.response = response
        mockURLSession.error = expectedError
        
        
        let url = URL(string: "https://example.com")!
        let request = URLRequest(url: url)
        
        service.getData(urlRequest: request) { (data, error) in
            // Assert
            XCTAssertNil(data)
            XCTAssertEqual(error as NSError?, expectedError)
        }

    }
}
