import Foundation

public enum Endpoint: String {
    private static let baseURL = "https://api.escuelajs.co/api/"
    private static let version = "v1/"
    
    enum QueryParameter: String {
        case offset
        case limit
    }

    case products
    case categories

    var url: String {
        return Endpoint.baseURL + Endpoint.version + self.rawValue
    }
    
    func urlWithParams(_ parameters: [QueryParameter: String]) -> String {
        var url = url + "?"
        for parameter in parameters {
            url += "\(parameter.key)=\(parameter.value)&"
        }
        return url
    }
}
