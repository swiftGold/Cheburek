protocol ModuleBuilderProtocol {
    func buildCatalogViewController(deliveryType: DeliveryType, address: String) -> CatalogViewController
    func buildMapViewController() -> MapViewController
    func buildSearchViewController() -> SearchViewController
}

final class ModuleBuilder {
    private var router: Router
    private let apiservice: APIServiceProtocol
    private let networkManager: NetworkManagerProtocol
    private let decoderManager: JSONDecoderManagerProtocol
    
    init(router: Router) {
        self.router = router
        self.decoderManager = JSONDecoderManager()
        self.networkManager = NetworkManager(jsonService: decoderManager)
        self.apiservice = APIService(
            networkManager: networkManager)
    }
}

extension ModuleBuilder: ModuleBuilderProtocol {
    func buildCatalogViewController(deliveryType: DeliveryType, address: String) -> CatalogViewController {
        
        let viewController = CatalogViewController()
        let presenter = CatalogPresenter(
            deliveryType: deliveryType,
            address: address,
            apiService: apiservice
        )
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildMapViewController() -> MapViewController {
        
        let viewController = MapViewController()
        let presenter = MapPresenter(router: router, moduleBuilder: self, apiService: apiservice)
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    func buildSearchViewController() -> SearchViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
