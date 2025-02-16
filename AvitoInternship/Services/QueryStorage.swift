import Foundation

final class QueryStorage {
    private let key = "lastQueries"
    private let maxCount = 5
    private let defaults = UserDefaults.standard

    var lastQueries: [String] {
        get {
            defaults.stringArray(forKey: key) ?? []
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }

    func saveQuery(_ query: String) {
        var queries = lastQueries
        if let index = queries.firstIndex(of: query) {
            queries.remove(at: index)
        }
        queries.append(query)
        if queries.count > maxCount {
            queries.removeFirst()
        }
        lastQueries = queries
    }
}
