import UIKit

final class ProductTableViewCell: UITableViewCell {
    
    private let productImageView = make(UIImageView()) {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let titleLabel = make(TitleLabel16()) {
        $0.text = ""
        $0.numberOfLines = 0
    }
    
    private let descriptionLabel = make(DescriptionLabel14()) {
        $0.text = ""
        $0.numberOfLines = 0
    }
    
    private let costLabel = make(WhiteLabelRubikMedium14()) {
        $0.text = ""
    }
  
    private lazy var addProductButton = make(UIButton(type: .system)) {
        $0.layer.cornerRadius = 10
        $0.setBackgroundImage(UIImage(asset: Asset.Assets.addtocart), for: .normal)
        $0.addTarget(self, action: #selector(addProductButtonTapped), for: .touchUpInside)
    }
    
    private var products: [ProductCellViewModel] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    @objc private func addProductButtonTapped() {
        print("Add product")
    }
}

extension ProductTableViewCell {
    func configureCell(with viewModel: ProductCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        costLabel.text = String(viewModel.price)
        productImageView.loadImage(from: viewModel.imageUrl)
    }
    
    func configurePlaceholder() {
        
        products = [
            .init(title: "", description: "", price: "", imageUrl: ""),
            .init(title: "", description: "", price: "", imageUrl: ""),
            .init(title: "", description: "", price: "", imageUrl: ""),
            .init(title: "", description: "", price: "", imageUrl: ""),
            .init(title: "", description: "", price: "", imageUrl: ""),
            .init(title: "", description: "", price: "", imageUrl: "")
        ]
    }
}

// MARK: - Private methods

private extension ProductTableViewCell {
    func setupCell() {
        backgroundColor = .carbon
        selectionStyle = .none
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        addSubview(contentView)
        myAddSubView(productImageView)
        myAddSubView(titleLabel)
        myAddSubView(descriptionLabel)
        myAddSubView(costLabel)
        myAddSubView(addProductButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            productImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            addProductButton.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 16),
            addProductButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            addProductButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addProductButton.widthAnchor.constraint(equalToConstant: 32),
            addProductButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        NSLayoutConstraint.activate([
            costLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 16),
            costLabel.centerYAnchor.constraint(equalTo: addProductButton.centerYAnchor)
        ])
    }
}
