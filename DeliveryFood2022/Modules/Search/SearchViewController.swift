import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    
}

final class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    
}
