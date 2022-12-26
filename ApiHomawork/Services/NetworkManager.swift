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
    case postRequest = "https://jsonplaceholder.typicode.com/posts"
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
    
    func postRequest(with data: [String: Any], from url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let serializedData = try? JSONSerialization.data(withJSONObject: data)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = serializedData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data, let response else {
                completion(.failure(.noData))
                return
            }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                completion(.success(json))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func postRequest2(with data: Purple, from url: String, completion: @escaping(Result<Any, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        guard let courseData = try? JSONEncoder().encode(data) else {
            completion(.failure(.noData))
            return
        }
        
        var request = URLRequest(url: url) // создаем запрос и то что в него дб вложено его тип
        request.httpMethod = "POST" //запомнить!!!
        request.httpBody = courseData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let course = try JSONDecoder().decode(Purple.self, from: data)
                completion(.success(course))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
       
    }
    
}


