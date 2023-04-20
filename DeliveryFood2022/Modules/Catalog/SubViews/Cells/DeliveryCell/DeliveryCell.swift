import UIKit

protocol DeliveryCellDelegate: AnyObject {
    func didTapChangeButton()
}

final class DeliveryCell: UITableViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let chooseView: UIView = {
        let view = UIView()
        view.backgroundColor = .specialBlack
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var deliveryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialWhite
        button.setTitle("Доставка", for: .normal)
        button.titleLabel?.font = UIFont(font: Fonts.Rubik.medium, size: 14)
        button.tintColor = .carbon
        button.addTarget(self, action: #selector(deliveryButtonTapped), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 6,
                                              left: 0,
                                              bottom: 0,
                                              right: 20)
        button.titleEdgeInsets = UIEdgeInsets(top: 2,
                                              left: 0,
                                              bottom: 0,
                                              right: 0)
        button.setImage(UIImage(asset: Asset.Assets.deliveryImage), for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private lazy var pickupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Самовывоз", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Medium", size: 14)
        button.tintColor = .specialLightGray
        button.addTarget(self, action: #selector(takeToGoButtonTapped), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 4,
                                              left: 30,
                                              bottom: 0,
                                              right: 0)
        
        button.titleEdgeInsets = UIEdgeInsets(top: 2,
                                              left: 50,
                                              bottom: 0,
                                              right: 0)
        button.setImage(UIImage(asset: Asset.Assets.takeToGoImage), for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let adresLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "ул. Центральная, 16"
        label.textColor = .specialWhite
        label.font = UIFont(name: "Rubik-Regular", size: 14)
        return label
    }()
    
    private lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitle("Изменить", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Regular", size: 14)
        button.tintColor = .signalYellow
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    weak var delegate: DeliveryCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func deliveryButtonTapped() {
        pickupButton.backgroundColor = .clear
        pickupButton.tintColor = .specialLightGray
        deliveryButton.backgroundColor = .specialWhite
        deliveryButton.tintColor = .carbon
    }
    
    @objc
    private func takeToGoButtonTapped() {
        pickupButton.backgroundColor = .specialWhite
        pickupButton.tintColor = .carbon
        deliveryButton.backgroundColor = .clear
        deliveryButton.tintColor = .specialLightGray
    }
    
    @objc
    private func changeButtonTapped() {
        delegate?.didTapChangeButton()
    }
}

// MARK: - Delegate

extension DeliveryCell: DeliveryCellDelegate {
    func didTapChangeButton() {
    }
}

// MARK: - Private methods

private extension DeliveryCell {
    func setupCell() {
        backgroundColor = .carbon
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        topStackView.addArrangedSubview(deliveryButton)
        topStackView.addArrangedSubview(pickupButton)
        
        bottomStackView.addArrangedSubview(adresLabel)
        bottomStackView.addArrangedSubview(changeButton)
        
        containerView.myAddSubView(chooseView)
        containerView.myAddSubView(topStackView)
        containerView.myAddSubView(bottomStackView)
        
        contentView.myAddSubView(containerView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            chooseView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            chooseView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chooseView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            chooseView.heightAnchor.constraint(equalToConstant: 41),
            
            topStackView.topAnchor.constraint(equalTo: chooseView.topAnchor, constant: 4),
            topStackView.trailingAnchor.constraint(equalTo: chooseView.trailingAnchor, constant: -4),
            topStackView.bottomAnchor.constraint(equalTo: chooseView.bottomAnchor, constant: -4),
            topStackView.leadingAnchor.constraint(equalTo: chooseView.leadingAnchor, constant: 4),
            
            bottomStackView.topAnchor.constraint(equalTo: chooseView.bottomAnchor, constant: 16),
            bottomStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            bottomStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            bottomStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
}

struct DeliveryCellViewModel {
    //TODO: -
}
