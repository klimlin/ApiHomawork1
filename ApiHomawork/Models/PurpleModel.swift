//
//  PurpleModel.swift
//  ApiHomawork
//
//  Created by MAcbook on 21.12.2022.
//


struct Purple: Codable {
    let activity: String
    let type: String
    let key: String
}

struct RickAndMorty: Decodable {
    let name: String
    let gender: String
    let type: String
    let status: String
    
}
