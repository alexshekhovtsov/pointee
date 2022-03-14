//
//  ApiClientMock.swift
//  pointee
//
//  Created by Alexander on 22.04.2020.
//  Copyright © 2020 Point. All rights reserved.
//

import Foundation

final class APIClientMock {
    
    var url: URL?
    let result: Data?
    let error: APIError?
    
    init(result: Data? = nil,
         error: APIError? = nil) {
        self.result = result
        self.error = error
    }
    
    init<T: Codable>(filename: String, modelType: T.Type) {
        let loader = MockLoader()
        let model: T! = loader.loadJson(filename: filename)
        self.result = loader.toData(model)
        self.error = nil
    }
    
    func fetch(with url: URL,
               handler: @escaping (Result<Data>) -> Void) {
        
        self.url = url
        
        guard let result = self.result else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                handler(.error(self.error ?? APIError.noData))
            }
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            handler(.success(result))
        }
    }
    
    /// Configure Call for API Request
    /// - Parameters:
    ///   - handler: ResultHandler<T>
    func call<T: Decodable>(handler: @escaping ResultHandler<T>) {
        self.fetch(with: URL(fileURLWithPath: "")) { (result) in
            
            switch result {
            case .success(let data):
                let decoder = JSONDecoder.isoDecoder()
                do {
                    let result = try decoder.decode(T.self, from: data)
                    handler(.success(result))
                } catch let error {
                    print(error.localizedDescription)
                    handler(.error(APIError.parsingError))
                }
                
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    /// Configure Call for API Request without Result
    /// - Parameters:
    ///   - handler: ResultHandler<Void>
    func callNoResult(handler: @escaping ResultHandler<Void>) {
        self.fetch(with: URL(fileURLWithPath: "")) { (result) in
            switch result {
            case .success:
                handler(.success(()))
            case .error(let error):
                handler(.error(error))
            }
        }
    }
    
    class MockLoader {
        func toData<T: Encodable>(_ encodable: T) -> Data? {

            let encoder = JSONEncoder.isoEncoder()
            return try? encoder.encode(encodable)
        }
        
        func loadJson<T: Decodable>(filename: String) -> T? {
            if let url = Bundle(for: type(of: self)).url(forResource: filename,
                                                         withExtension: "json"),
                let data = try? Data(contentsOf: url) {
                
                let decoder = JSONDecoder.isoDecoder()
                let jsonData = try? decoder.decode(T.self, from: data)
                return jsonData
            }
            return nil
        }
    }
}
