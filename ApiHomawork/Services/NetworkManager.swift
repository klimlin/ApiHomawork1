//
//  NetworkManager.swift
//  ApiHomawork
//
//  Created by MAcbook on 25.12.2022.
//

import Foundation

enum Link: String {
    case helloURL = "https://www.boredapi.com/api/activity"
    case byeURL = "https://rickandmortyapi.com/api/character/108"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchHello(from url: String, completion: @escaping(Result<Purple, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let purple = try JSONDecoder().decode(Purple.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(purple))
                }
            } catch {
                    completion(.failure(.decodingError))
                }
            }.resume()
    }
    
    func fetchBye(from url: String, completion: @escaping(Result<RickAndMorty, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let rickAndMorty = try JSONDecoder().decode(RickAndMorty.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(rickAndMorty))
                }
            } catch {
                    completion(.failure(.decodingError))
                }
            }.resume()
    }
    
}


