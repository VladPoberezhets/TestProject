//
//  NetworkManager+Extension.swift
//  TestProject
//
//  Created by Vlad Poberezhets on 11.01.2025.
//

import Foundation

extension NetworkManager {
    func validateResponse(_ response: URLResponse?, data: Data?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            print(error.localizedDescription)
            return .failure(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print(NetworkError.noData.errorDescription)
            return .failure(NetworkError.noData)
        }
        
        guard (200...300).contains(httpResponse.statusCode) else {
            print(NetworkError.serverError(statusCode: httpResponse.statusCode).errorDescription)
            return .failure(NetworkError.serverError(statusCode: httpResponse.statusCode))
        }
        
        guard let data = data else {
            print(NetworkError.noData.errorDescription)
            return .failure(NetworkError.noData)
        }
        return .success(data)
    }
}
