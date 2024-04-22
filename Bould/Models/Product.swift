import Foundation


struct ProductGroup {
    let category: ProductCategory
    var products: [Product]
    var page: Int = 1
    var isNoMoreProducts: Bool = false
}

struct ProductCategory: Codable {
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
//"video": null,
struct Product: Codable {
    let id: Int?
    let category: ProductCategory?
    let title, brand: String?
    let label: String?
    let actualPrice, soldPrice: Int?
    let imageURL: String?
    let currency: String?
    let color: String?
    let enableProduct: Bool?
    let stockStatus: String?
    let sizeRange: String?
    let createdAt, updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case title, brand, label
        case actualPrice = "actual_price"
        case soldPrice = "sold_price"
        case imageURL = "img_url"
        case currency, color
        case enableProduct = "enable_product"
        case stockStatus = "stock_status"
        case sizeRange = "size_range"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
    }
}
