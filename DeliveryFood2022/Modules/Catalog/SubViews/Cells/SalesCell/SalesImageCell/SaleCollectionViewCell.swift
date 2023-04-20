import UIKit

final class SaleCollectionViewCell: UICollectionViewCell {
    
    private let imageView = make(UIImageView()) {
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = .specialGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: SaleCellViewModel) {
        imageView.backgroundColor = .clear
        imageView.loadImage(from: viewModel.imageUrl)
    }
    
    func configurePlaceholderCell() {
        imageView.backgroundColor = .specialGray
    }
}

private extension SaleCollectionViewCell {
    func setupCell() {
        contentView.myAddSubView(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
