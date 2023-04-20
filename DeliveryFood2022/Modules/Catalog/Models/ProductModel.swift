struct ProductResponseModel: Decodable {
    var id: Int
    var categoryId: Int
    var title: String
    var description: String
    var imageUrlString: String
    var price: Double
    var currency: String
}

struct ProductModel: Decodable {
    var id: Int
    var categoryId: Int
    var title: String
    var description: String
    var imageUrlString: String
    var price: Double
    var currency: String
    
    init(
        id: Int,
        categoryId: Int,
        title: String,
        description: String,
        imageUrlString: String,
        price: Double,
        currency: String
    )
    {
        self.id = id
        self.categoryId = categoryId
        self.title = title
        self.description = description
        self.imageUrlString = imageUrlString
        self.price = price
        self.currency = currency
    }
    
    init(_ response: ProductResponseModel) {
        id = response.id
        categoryId = response.categoryId
        title = response.title
        description = response.description
        imageUrlString = response.imageUrlString
        price = response.price
        currency = response.currency
    }
}

