//
//  Info.swift
//  RickAndMortyApp
//
//  Created by Rafael Martins on 02/03/21.
//

import Foundation

struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String?

    func nextPage() -> String {
        return trimPageURL(next)
    }

    func previousPage() -> String? {
        return trimPageURL(prev ?? "1")
    }

    func currentPage() -> String {

        if nextPage() != "" {
            if let nextPageInt = Int(nextPage()) {
                return "\(nextPageInt - 1)"
            }
        }
        else if previousPage() != "" {
            if let previousPageInt = Int(previousPage() ?? "1") {
                return "\(previousPageInt + 1)"
            }
        }

        return "1"
    }

    private func trimPageURL(_ urlString: String) -> String {
        if let index = urlString.range(of: "=")?.upperBound {
            let pageSubString = (urlString[index...])
            let pageNum = String(pageSubString)
            return pageNum
        }
        return ""
    }
}
