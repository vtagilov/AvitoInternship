//
//  SearchSuggester.swift
//  AvitoInternship
//
//  Created by Владимир on 12.09.2024.
//

import Foundation

final class SearchSuggester {
    private let key = "SearchSuggesterKey"
    private let historySize = 5
    private let userDefaults = UserDefaults()
    
    private lazy var suggests: [String] = {
        let array = userDefaults.array(forKey: self.key)
        if let strArray = array as? [String] {
            return strArray
        }
        return []
    }()
    
    func addQuery(_ query: String) {
        if let index = suggests.firstIndex(of: query) {
            suggests.remove(at: index)
        }
        suggests.insert(query, at: 0)
        if suggests.count > historySize {
            suggests.removeLast()
        }
        updateSuggests()
    }
    
    func getSuggests(_ query: String) -> [String] {
        if query.isEmpty { return suggests }
        let filtredSuggests = suggests.filter { $0.lowercased().contains(query.lowercased()) }
        return filtredSuggests
    }
    
    private func updateSuggests() {
        userDefaults.setValue(suggests, forKey: key)
    }
}
