import Foundation
import GoogleMaps
import MapKit

protocol MapPresenterProtocol {
    func didChangePosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    func didTapSearchButton()
    func didTapNExtButton()
}

final class MapPresenter {
    weak var viewController: MapViewControllerProtocol?
    
    private var latitude: CLLocationDegrees = .zero
    private var longitude: CLLocationDegrees = .zero
    private var address: String = ""
    private var deliveryType: DeliveryType = .delivery
    
    private let router: Router
    private let moduleBuilder: ModuleBuilderProtocol
    private let apiService: APIServiceProtocol
    
    init(
        router: Router,
        moduleBuilder: ModuleBuilderProtocol,
        apiService: APIServiceProtocol
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
        self.apiService = apiService
    }
}

extension MapPresenter: MapPresenterProtocol {
    func didChangePosition(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Task {
            do {
                let response = try await apiService.fetchGeocoding(latitude: latitude, longitude: longitude)
                await MainActor.run {
                    if let address = response.results.first?.formattedAddress {
                        self.address = address
                        viewController?.update(address: address)
                    } else {
                        print("error, adress response is not found")
                    }
                }
            } catch {
                print(error, error.localizedDescription)
            }
        }
    }
    
    func didTapSearchButton() {
        let searchViewController = moduleBuilder.buildSearchViewController()
        router.push(searchViewController, animated: true)
    }
    
    func didTapNExtButton() {
        let catalogViewController = moduleBuilder.buildCatalogViewController(deliveryType: deliveryType, address: address)
        router.push(catalogViewController, animated: true)
    }
}

enum DeliveryType {
    case delivery
    case pickup
}
