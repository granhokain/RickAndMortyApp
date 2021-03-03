//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 02/03/21.
//

import Foundation

struct CharacterResponse: Decodable {
    let info: Info
    let results: [Character]
}

struct CharacterLocation: Decodable {
    let name: String
    let url: String
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
