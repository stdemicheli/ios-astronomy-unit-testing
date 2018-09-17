//
//  AstronomyTests.swift
//  AstronomyTests
//
//  Created by De MicheliStefano on 17.09.18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import XCTest
@testable import Astronomy

class MockLoader: NetworkDataLoader {
    
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    let data: Data?
    let error: Error?
    private(set) var request: URLRequest? = nil
    private(set) var url: URL? = nil
    
    
    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        self.request = request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        self.url = url
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.error)
        }
    }
    
}

class MarsRoverClientTests: XCTestCase {

    override func setUp() {
        
    }
    
    func testValidRoverData() {
        let mockLoader = MockLoader(data: validRoverJSON, error: nil)
        let marsRoverClient = MarsRoverClient(dataLoader: mockLoader)
        
        let expectation = self.expectation(description: "Perform MarsRover Fetch")
        marsRoverClient.fetchMarsRover(named: "Curiosity") { (rover, error) in
            XCTAssertNotNil(mockLoader.url)
            XCTAssertNotNil(rover)
            XCTAssertEqual("Curiosity", rover!.name)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
