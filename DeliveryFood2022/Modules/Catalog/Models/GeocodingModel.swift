struct GeocodingResponse: Decodable {
    let results: [GeocodingResult]
}

struct GeocodingResult: Decodable {
    let formattedAddress: String
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
    }
}
