
//"https://gist.github.com/swiftGold/f81354b11c09dc99fee89d674ea51088"

protocol APIServiceProtocol {
    func fetchSales(_ completion: @escaping (Result<[SaleResponseModel], Error>) -> Void)
    func fetchCategories(_ completion: @escaping (Result<[CategoryResponseModel], Error>) -> Void)
    func fetchProducts(_ completion: @escaping (Result<[ProductResponseModel], Error>) -> Void)
    func fetchSales() async throws -> [SaleResponseModel]
    func fetchCategories() async throws -> [CategoryResponseModel]
    func fetchProducts() async throws -> [ProductResponseModel]
    func fetchGeocoding(latitude: Double, longitude: Double) async throws -> GeocodingResponse
}

final class APIService {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension APIService: APIServiceProtocol {
    
    func fetchSales(_ completion: @escaping (Result<[SaleResponseModel], Error>) -> Void) {
        
        let urlString = "https://gist.githubusercontent.com/swiftGold/f81354b11c09dc99fee89d674ea51088/raw/09f532dd74314789e165cad999e36dfd8f56cf9f/Promotions.json"
        networkManager.request(urlString: urlString, completion: completion)
    }
    
    func fetchCategories(_ completion: @escaping (Result<[CategoryResponseModel], Error>) -> Void) {
        
        let urlString = "https://gist.githubusercontent.com/swiftGold/f81354b11c09dc99fee89d674ea51088/raw/2defa88b670bbb92b6bf49e753aada81ddb6c6cc/Categories.json"
        networkManager.request(urlString: urlString, completion: completion)
    }
    
    func fetchProducts(_ completion: @escaping (Result<[ProductResponseModel], Error>) -> Void) {
        
        let urlString = "https://gist.githubusercontent.com/swiftGold/f81354b11c09dc99fee89d674ea51088/raw/83bb0d916174a24d5008c4b08848f1eef9093b5c/Products.json"
        networkManager.request(urlString: urlString, completion: completion)
    }
    
    func fetchSales() async throws -> [SaleResponseModel] {
        let urlString = "https://gist.githubusercontent.com/swiftGold/f81354b11c09dc99fee89d674ea51088/raw/09f532dd74314789e165cad999e36dfd8f56cf9f/Promotions.json"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchCategories() async throws -> [CategoryResponseModel] {
        
        let urlString = "https://gist.githubusercontent.com/swiftGold/f81354b11c09dc99fee89d674ea51088/raw/2defa88b670bbb92b6bf49e753aada81ddb6c6cc/Categories.json"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchProducts() async throws -> [ProductResponseModel] {
        
        let urlString = "https://gist.githubusercontent.com/swiftGold/f81354b11c09dc99fee89d674ea51088/raw/83bb0d916174a24d5008c4b08848f1eef9093b5c/Products.json"
        return try await networkManager.request(urlString: urlString)
    }
    
    func fetchGeocoding(latitude: Double, longitude: Double) async throws -> GeocodingResponse {
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(Constants.googleMapsKey)"
        return try await networkManager.request(urlString: urlString)
    }
}
