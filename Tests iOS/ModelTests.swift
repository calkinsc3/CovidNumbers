//
//  ModelTests.swift
//  Tests iOS
//
//  Created by William Calkins on 8/9/20.
//

import Foundation
import CovidNumbers
import XCTest

class ModelTests: XCTestCase {
    
    let jsonDecoder = JSONDecoder()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStateModels() throws {
        
        let stateData = getMockData(forResource: "States")
        XCTAssertNotNil(stateData, "State mock did not load.")
        
        //decode the data
//        if let givenStateData = stateData {
//            do {
//                let stateModels = try jsonDecoder.decode(StateData.self, from: givenStateData)
//                XCTAssertTrue(stateModels.count == 56, "State count should be 56. Count is \(stateModels.count)")
//            } catch  {
//                XCTFail("Failed to decode State data: \(error)")
//            }
//        }
    }
    
    func testCountryModels() throws {
        
    }
    
    //MARK:- Helper Functions
    private func createPath(forJSONFile: String) -> URL {
        
        let jsonURL = URL(
            fileURLWithPath: forJSONFile,
            relativeTo: FileManager.documentDirectoryURL?.appendingPathComponent("\(forJSONFile)")
        ).appendingPathExtension("json")
        
        print("json path for \(forJSONFile) = \(jsonURL.absoluteString)")
        
        return jsonURL
    }
    
    private func getMockData(forResource: String) -> Data? {
        
        //This is included in they myamfam target becasue it will be used the app.
        let currentBundle = Bundle(for: type(of: self))
        if let pathForRecommendationMock = currentBundle.url(forResource: forResource, withExtension: "json") {
            do {
                return try Data(contentsOf: pathForRecommendationMock)
            } catch {
                XCTFail("Unable to convert \(pathForRecommendationMock) to Data.")
                return nil
            }
        } else {
            XCTFail("Unable to load \(forResource).json.")
            return nil
        }
        
    }

}

extension FileManager {
    static var documentDirectoryURL: URL? {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        } catch {
            return nil //if there is an error return nil
        }
    }
}
