import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel = make(WhiteLabelRubikMedium14()) {
        $0.text = ""
        $0.textAlignment = .center
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: CategoryCellViewModel) {
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.isSelected ? .specialBlack : .specialWhite
        titleLabel.backgroundColor = viewModel.isSelected ? .signalYellow : .clear
    }
    
    func configurePlaceholderCell() {
        titleLabel.backgroundColor = .specialGray
    }
}

// MARK: - Private methods

private extension CategoryCollectionViewCell {
    func setupCell() {
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        contentView.myAddSubView(titleLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
