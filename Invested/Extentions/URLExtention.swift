//
//  URLExtention.swift
//  Invested
//
//  Created by Ben Leembruggen on 3/5/21.
//  Sourced: https://stackoverflow.com/questions/34060754/how-can-i-build-a-url-with-query-parameters-containing-multiple-values-for-the-s

import Foundation

extension URL {
    //Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    // URL must conform to RFC 3986.
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

        // return the url from new url components
        return urlComponents.url
    }
}
