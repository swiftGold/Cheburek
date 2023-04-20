struct CategoryResponseModel: Decodable {
    //то во что декодируем из json ответа. Содержит в себе тоже самое, что и json модель
    let id: Int
    let title: String
}

// то, с чем работаем в презенторе. Содержит в себе достаточное количество сырой информации для различных манипуляций
struct CategoryModel {
    let id: Int
    let title: String
    var isSelected: Bool
    
    init(
        id: Int,
        title: String,
        isSelected: Bool
    ) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
    }
    
    init(_ response: CategoryResponseModel) {
        self.id = response.id
        self.title = response.title
        self.isSelected = false
    }
}
