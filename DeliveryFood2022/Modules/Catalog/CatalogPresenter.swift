import Foundation
import RealmSwift

protocol CatalogPresenterProtocol: AnyObject {
    var viewController: CatalogViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func viewDidLoadAsync()
    func didTapCell(at index: Int)
}

final class CatalogPresenter {
    weak var viewController: CatalogViewControllerProtocol?
    
    private var sales: [SaleModel] = []
    private var categories: [CategoryModel] = []
    private var products: [ProductModel] = []
    private var apiService: APIServiceProtocol
    
    private var deliveryType: DeliveryType
    private var address: String
    
    init(
        deliveryType: DeliveryType,
        address: String,
        apiService: APIServiceProtocol
    ) {
        self.deliveryType = deliveryType
        self.address = address
        self.apiService = apiService
    }
}

//MARK: - CatalogPresenter extension

extension CatalogPresenter: CatalogPresenterProtocol {
    
    func viewDidLoadAsync() {
        viewController?.showPlaceHolders()
        Task(priority: .utility) {
            do {
                let salesResponse = try await apiService.fetchSales()
                let categoriesResponse = try await apiService.fetchCategories()
                let productsResponse = try await apiService.fetchProducts()
                
                sales = salesResponse.map { sale in
                    SaleModel(sale)
                }
                
//                categories = categoriesResponse.enumerated().map { index, category in
//                    CategoryModel(
//                        id: category.id,
//                        title: category.title,
//                        isSelected: index == 0 ? true : false
//                    )
//                }
                
                categories = categoriesResponse.map { CategoryModel($0) }
                if !categories.isEmpty {
                    categories[.zero].isSelected = true
                }
                
                products = productsResponse.map { ProductModel($0) }
                
                await MainActor.run(body: {
                    updateTableView()
                })
            } catch {
                await MainActor.run(body: {
                    print(error, error.localizedDescription)
                    viewController?.showError()
                })
            }
        }
    }
    
    func viewDidLoad() {
        viewController?.showPlaceHolders()
        DispatchQueue.global().async { [weak self] in
            let group = DispatchGroup()
            
            group.enter()
            
            self?.apiService.fetchCategories { result in
                switch result {
        
                case .success(let response):
                    self?.categories = response.enumerated().map { index, category in
                        CategoryModel(
                            id: category.id,
                            title: category.title,
                            isSelected: index == 0 ? true : false
                        )
                    }
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
                group.leave()
            }
            
            group.wait()
            group.enter()

            self?.apiService.fetchSales { result in
                switch result {
                    
                case .success(let response):
                    self?.sales = response.map { sale in
                        SaleModel(sale)
                    }
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
                group.leave()
            }
            
            group.wait()
            group.enter()
            
            self?.apiService.fetchProducts { result in
                switch result {
                //смапили, потому что приписали init у модели
                case .success(let response):
                    self?.products = response.map {
                        ProductModel($0)
                    }
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
                group.leave()
            }
            
            group.wait()
            
            group.notify(queue: DispatchQueue.main) {
                self?.updateTableView()
            }
        }
    }
    
    func didTapCell(at index: Int) {
        categories.enumerated().forEach { modelIndex, modelValue in
            if modelIndex == index {
                categories[modelIndex].isSelected = true
            } else {
                categories[modelIndex].isSelected = false
            }
        }
        updateTableView()
    }
}

//MARK: - Private methods
private extension CatalogPresenter {
    func updateTableView() {
        
        let section: [Catalog.Section] = [
        makeSalesSection(),
        makeProductSection()
        ]
        viewController?.updateTableView(section)
    }
    
    func makeSalesSection() -> Catalog.Section {
        let viewModel = sales.map {
            SaleCellViewModel(imageUrl: $0.imageUrlString)
        }
        let salesViewModel = SalesCellViewModel(sales: viewModel)
        let section = Catalog.Section(type: .sales, rows: [.sales(viewModel: salesViewModel)])
        
        return section
    }
    
    func makeCategoriesHeaderViewModel() -> CategoriesHeaderViewModel {
        let viewModel = categories.map { category -> CategoryCellViewModel in
            CategoryCellViewModel(title: category.title, isSelected: category.isSelected)
        }
        let result = CategoriesHeaderViewModel(categories: viewModel)

        return result
    }
    
    func makeProductSection() -> Catalog.Section {
        let rows = products.map { product -> Catalog.Row in
            let viewModel = ProductCellViewModel(
                title: product.title,
                description: product.description,
                price: "\(product.price) \(product.currency)",
                imageUrl: product.imageUrlString
            )
            return Catalog.Row.product(viewModel: viewModel)
        }
        let categoriesHeaderViewModel = makeCategoriesHeaderViewModel()
        let result = Catalog.Section(type: .products(categoriesHeaderViewModel), rows: rows)
        return result
    }
}

enum NameSpace {
    
    struct CategoryResponseModel {
        let id: String
        let title: String
    }
    
    struct CategoryModel {
        let id: String
        let title: String
        var isSelected: Bool
    }
    
    struct CategoryViewModel {
        let title: String
        let isSelected: Bool
    }
}
