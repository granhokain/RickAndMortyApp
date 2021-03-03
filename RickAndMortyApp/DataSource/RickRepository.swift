//
//  RickRepository.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 02/03/21.
//

import Foundation
import Moya
import Alamofire

protocol Networkable {
    var provider: MoyaProvider<RickRemoteDataSource> { get }
    func getCharacter(name: String,
                      page: String,
                      completion: @escaping ([Character], Info) -> Void)
    func getCharactersWith(ids: String,
                           completion: @escaping ([Character]) -> Void)
    func getLocation(name: String,
                     page: String,
                     completion: @escaping ([Location], Info) -> Void)
    func getEpisode(name: String,
                    page: String,
                    completion: @escaping ([Episode], Info) -> Void)
}

struct NetworkManager: Networkable {

    var provider = MoyaProvider<RickRemoteDataSource>(plugins: [NetworkLoggerPlugin(verbose: true)])

    func getCharacter(name: String,
                      page: String,
                      completion: @escaping ([Character], Info) -> Void) {
        provider.request(.character(name: name, page: page), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(CharacterResponse.self, from: response.data)
                    completion(results.results, results.info)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            case let .failure(error):

                if let reachabilityManger = NetworkReachabilityManager(){
                    if !reachabilityManger.isReachable {
                        print("offline")
                    }
                }

                print(error.localizedDescription)
            }
        })
    }

    func getCharactersWith(ids: String, completion: @escaping ([Character]) -> Void) {
        provider.request(.charactersWith(ids: ids), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode([Character].self, from: response.data)
                    completion(results)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            case let .failure(error):

                if let reachabilityManger = NetworkReachabilityManager(){
                    if !reachabilityManger.isReachable {
                        print("offline")
                    }
                }

                print(error.localizedDescription)
            }
        })
    }

    func getLocation(name: String,
                     page: String,
                     completion: @escaping ([Location], Info) -> Void) {

        provider.request(.location(name: name, page: page), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(LocationResponse.self, from: response.data)
                    completion(results.results, results.info)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            case let .failure(error):

                if let reachabilityManger = NetworkReachabilityManager(){
                    if !reachabilityManger.isReachable {
                        print("offline")
                    }
                }

                print(error.localizedDescription)
            }
        })

    }

    func getEpisode(name: String,
                    page: String,
                    completion: @escaping ([Episode], Info) -> Void) {

        provider.request(.episode(name: name, page: page), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(EpisodeResponse.self, from: response.data)
                    completion(results.results, results.info)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            case let .failure(error):

                if let reachabilityManger = NetworkReachabilityManager(){
                    if !reachabilityManger.isReachable {
                        print("offline")
                    }
                }

                print(error.localizedDescription)
            }
        })

    }
}
