//
//  LocationViewModel.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 04/03/21.
//

import Foundation
import UIKit
import Moya
import Alamofire

final class LocationViewModel {
    private var repository = MoyaProvider<RickRemoteDataSource>(plugins: [NetworkLoggerPlugin(verbose: true)])

    var startLoading: (() -> Void)?
    var endLoading: (() -> Void)?
    var showError: ((String, String) -> Void)?
    var showLocation: (([Location], Info) -> Void)?

    init(repository: MoyaProvider<RickRemoteDataSource> = .init()) {
        self.repository = repository
    }

    func getLocation(name: String, page: String) {
        startLoading?()
        repository.request(.location(name: name, page: page), completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(LocationResponse.self, from: response.data)
                    self.endLoading?()
                    self.showLocation?(results.results, results.info)
                }
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
}

