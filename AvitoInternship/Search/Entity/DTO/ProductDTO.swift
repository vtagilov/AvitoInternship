struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let category: CategoryDTO
    let images: [String]
}
