import UIKit

final class SalesTableViewCell: UITableViewCell {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: 310, height: 106)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SaleCollectionViewCell.self, forCellWithReuseIdentifier: "SalesImageCell")        
        return collectionView
    }()
    
    private var sales: [SaleCellViewModel] = []
    private var isPlaceholder = false
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func configureCell(with viewModel: SalesCellViewModel) {
        isPlaceholder = false
        sales = viewModel.sales
        collectionView.reloadData()
    }
    
    func configurePlaceHolder() {
        isPlaceholder = true
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource Impl

extension SalesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sales.count
        return isPlaceholder ? 3 : sales.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SalesImageCell", for: indexPath) as? SaleCollectionViewCell else { fatalError("")
        }
        if isPlaceholder {
            cell.configurePlaceholderCell()
        } else {
            let viewModel = sales[indexPath.item]
            cell.configureCell(with: viewModel)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate Impl

extension SalesTableViewCell: UICollectionViewDelegate {
}

// MARK: - Private methods

private extension SalesTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        addSubviews()
        setConstraints()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func addSubviews() {
        contentView.myAddSubView(collectionView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: 106)
        ])
    }
}
