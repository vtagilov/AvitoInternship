import Foundation

public enum Endpoint: String {
    private static let baseURL = "https://api.escuelajs.co/api/"
    private static let version = "v1/"

    case products
    case categories

    var url: String {
        return Endpoint.baseURL + Endpoint.version + self.rawValue
    }
}
