import UIKit
import GoogleMaps

protocol MapViewControllerProtocol: AnyObject {
    func update(address: String)
}

final class MapViewController: UIViewController {

    private var pinImageView = make(UIImageView()) {
        $0.image = UIImage(asset: Asset.Assets.pin)
    }
    
    private lazy var deliveryView = make(DeliveryView()) {
        $0.layer.cornerRadius = 16
        $0.delegate = self
    }
    
    private let mapView = GMSMapView()
    private let locationManager = CLLocationManager()
    
    var presenter: MapPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapViewController()
    }
}

extension MapViewController: MapViewControllerProtocol {
    func update(address: String) {
        deliveryView.configureView(adress: address)
        deliveryView.isHidden = false
    }
}

extension MapViewController: GMSMapViewDelegate {
    //скрывает меню во время перемещения по карте
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        deliveryView.isHidden  = true
    }
    //передает координаты указателя после остановки движения по карте
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        presenter?.didChangePosition(latitude: position.target.latitude, longitude: position.target.longitude)
        
        print(position.target.latitude, position.target.longitude)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 16.0)
            mapView.camera = camera
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            showAlertLocation(title: "Вы запретили определение местоположения", message: "Хотите это изменить?", url: URL(string: UIApplication.openSettingsURLString))
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            print("не выбран ни один из вариантов")
        }
    }
}

extension MapViewController: DeliveryViewDelegate {
    func didTapSearchButton() {
        presenter?.didTapSearchButton()
    }
    
    func didTapNExtButton() {
        presenter?.didTapNExtButton()
    }
}

private extension MapViewController {
    func setupMapViewController() {
        view.backgroundColor = .red
        
        addSubviews()
        setConstraints()
        
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    func addSubviews() {
        view.myAddSubView(mapView)
        view.myAddSubView(pinImageView)
        view.myAddSubView(deliveryView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            pinImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pinImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 2 - 22),
            pinImageView.heightAnchor.constraint(equalToConstant: 44),
            pinImageView.widthAnchor.constraint(equalToConstant: 29),
            
            deliveryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deliveryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            deliveryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func showAlertLocation(title: String, message: String?, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
