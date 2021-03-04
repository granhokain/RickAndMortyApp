//
//  EpisodeViewModel.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import Foundation
import UIKit
import Moya
import Alamofire

final class EpisodeViewModel {
    private var repository = MoyaProvider<RickRemoteDataSource>(plugins: [NetworkLoggerPlugin(verbose: true)])

    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    var showError: ((String, String) -> Void)?
    var showEpisode: (([Episode], Info) -> Void)?
    var showEpisodeCharacter: (([Character]) -> Void)?

    init(repository: MoyaProvider<RickRemoteDataSource> = .init()) {
        self.repository = repository
    }

    func getEpisode(name: String, page: String) {
        startLoading?()
        repository.request(.episode(name: name, page: page), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(EpisodeResponse.self, from: response.data)
                    self.endLoading?()
                    self.showEpisode?(results.results, results.info)                }
                catch let error {
                    self.showError?("Something wrong!", error.localizedDescription)
                }
            case let .failure(error):
                self.endLoading?()
                self.showError?("Something wrong!", error.localizedDescription)

                if let reachabilityManger = NetworkReachabilityManager(){
                    if !reachabilityManger.isReachable {
                        print("offline")
                    }
                }
            }
        })
    }

    func getCharactersWith(ids: String) {
        startLoading?()
        repository.request(.charactersWith(ids: ids), completion: { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode([Character].self, from: response.data)
                    self.endLoading?()
                    self.showEpisodeCharacter?(results)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                self.endLoading?()
                self.showError?("Something wrong!", error.localizedDescription)

                if let reachabilityManger = NetworkReachabilityManager(){
                    if !reachabilityManger.isReachable {
                        print("offline")
                    }
                }
            }
        })
    }
}

