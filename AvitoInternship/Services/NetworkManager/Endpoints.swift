import Foundation

public enum Endpoint: String {
    private static let baseURL = "https://api.escuelajs.co/api/"
    private static let version = "v1/"
    
    enum QueryParameter: String {
        case offset
        case limit
        case title
        case priceMin = "price_min"
        case priceMax = "price_max"
        case categoryId
    }

    case products
    case categories

    var url: String {
        return Endpoint.baseURL + Endpoint.version + self.rawValue
    }
    
    func urlWithParams(_ parameters: [QueryParameter: String?], _ filter: FilterContext?) -> String {
        var url = url + "?"
        for parameter in parameters {
            if let value = parameter.value {
                url += "\(parameter.key)=\(value)&"
            }
        }
        if let filter = filter {
            for (key, value) in filter.convertToUrlParams() {
                if let value = value {
                    url += "\(key.rawValue)=\(value)&"
                }
            }
        }
        return url
    }
}
