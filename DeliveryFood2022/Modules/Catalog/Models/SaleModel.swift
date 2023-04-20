struct SaleResponseModel: Decodable {
    let id: Int
    let imageUrlString: String
}

struct SaleModel {
    let id: Int
    let imageUrlString: String
    
    init(id: Int, imageUrlString: String) {
        self.id = id
        self.imageUrlString = imageUrlString
    }
    
    init(_ response: SaleResponseModel) {
        id = response.id
        imageUrlString = response.imageUrlString
    }
}

