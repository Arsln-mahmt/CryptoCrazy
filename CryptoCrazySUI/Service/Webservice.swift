//
//  Webservice.swift
//  CryptoCrazySUI
//
//  Created by Mahmut Arslan on 19.03.2024.
//

import Foundation

class Webservice {
    
    /*
    func downloadCurrenciesAsync(url: URL) async throws -> [CryptoCurrency] {
        
       let (data, _ ) = try await URLSession.shared.data(from: url)
  
        let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data)
        
        return currencies ?? []
     
    }
    */
    
    func downloadCurrenciesContinuaiton(url: URL) async throws -> [CryptoCurrency] {
        
        try await withCheckedThrowingContinuation { continuation in
            downloadCurrencies(url: url) { result in
                switch result {
                    
                case.success(let cryptos):
                    continuation.resume(returning: cryptos ?? [])
                case.failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func downloadCurrencies(url : URL, completion : @escaping (Result<[CryptoCurrency]?,DownloaderErrorr>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.badUrl))
                
            }
            
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
                
            }
            
            guard let currencies = try? JSONDecoder().decode([CryptoCurrency].self, from: data) else {
                return completion(.failure(.dataParseError))
                
            }
            completion(.success(currencies))
            
        }.resume()
     
    }
    
    
}

enum DownloaderErrorr : Error {
    case badUrl
    case noData
    case dataParseError
}
