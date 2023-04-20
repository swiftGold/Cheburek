import UIKit

protocol CatalogViewControllerProtocol: AnyObject {
    var presenter: CatalogPresenterProtocol? { get set }
    func showPlaceHolders()
    func updateTableView(_ sectionViewModel: [Catalog.Section])
    func showError()
}

class CatalogViewController: UIViewController {
    var presenter: CatalogPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SalesTableViewCell.self,
            DeliveryCell.self,
            ProductTableViewCell.self
        )
        return tableView
    }()
    
    private var sectionViewModel: [Catalog.Section] = []
    
    private let headerView = CategoriesTableHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
}

extension CatalogViewController: DeliveryCellDelegate {
    func didTapChangeButton() {
    }
}

//MARK: - CatalogViewControllerProtocol Impl

extension CatalogViewController: CatalogViewControllerProtocol {
    func showPlaceHolders() {
        sectionViewModel = [
            .init(type: .salesPlaceHolder, rows: [.salesPlaceHolder])
        ]
        tableView.reloadData()
    }
    
    func updateTableView(_ sectionViewModel: [Catalog.Section]) {
        self.sectionViewModel = sectionViewModel
        tableView.reloadData()
    }
    func showError() {

    }
}

//MARK: - CategoriesTableHeaderViewDelegate

extension CatalogViewController: CategoriesTableHeaderViewDelegate {
    func didTapCell(at index: Int) {
        presenter?.didTapCell(at: index)
    }
}

//MARK: - UITableViewDelegate Impl
extension CatalogViewController: UITableViewDelegate {
}

//MARK: - UITableViewDataSource Impl
extension CatalogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionViewModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionViewModel[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let rowType = sectionViewModel[section].rows[row]
        
        switch rowType {
        case .sales(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: SalesTableViewCell.self, for: indexPath)
            cell.configureCell(with: viewModel)
            return cell
            
        case .delivery(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: DeliveryCell.self, for: indexPath)
            cell.delegate = self
            //            cell.configureCell(with: viewModel, delegate: delegate)
            return cell
            
        case .product(let viewModel):
            let cell = tableView.dequeueReusableCell(withType: ProductTableViewCell.self, for: indexPath)

            cell.configureCell(with: viewModel)
//            cell.configurePlaceholder()
            return cell
            
        case .salesPlaceHolder:
            let cell = tableView.dequeueReusableCell(withType: SalesTableViewCell.self, for: indexPath)
            cell.configurePlaceHolder()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sectionViewModel[section].type {
        case let .products(viewModel):

            headerView.configureHeader(with: viewModel)
            headerView.delegate = self
            return headerView
        case .sales,
             .delivery,
             .salesPlaceHolder:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sectionViewModel[section].type {
        case .products(_):
            return 60
            
        default:
            return 0
        }
        
    }
}

//MARK: - Private methods
private extension CatalogViewController {
    func setupViewController() {
        view.backgroundColor = .carbon
        
        addSubviews()
        setConstraint()
//        presenter?.viewDidLoad()
        presenter?.viewDidLoadAsync()
    }
    
    func addSubviews() {
        view.addSubview(tableView)
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



