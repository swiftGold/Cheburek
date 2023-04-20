import UIKit

protocol DeliveryViewDelegate: AnyObject {
    func didTapSearchButton()
    func didTapNExtButton()
}

final class DeliveryView: UIView {
    
    //метод make в папке Helpers
    private let titleLabel = make(WhiteLabelRubikRegular14()) { label in
        label.text = "Title"
        label.numberOfLines = 0
    }
    
    private lazy var searchButton = make(UIButton(type: .system)) {
        $0.setTitle("Search", for: .normal)
        $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        $0.setTitleColor(.signalYellow, for: .normal)
        $0.titleLabel?.font = UIFont(font: Fonts.Rubik.regular, size: 14)
    }
    
    private lazy var nextButton = make(UIButton(type: .system)) {
        $0.setTitle("Next", for: .normal)
        $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .signalYellow
        $0.setTitleColor(.carbon, for: .normal)
        $0.titleLabel?.font = UIFont(font: Fonts.Archive.regular, size: 16)
    }
    
    weak var delegate: DeliveryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(adress: String) {
        titleLabel.text = adress
    }
    
    @objc
    private func didTapSearchButton() {
        delegate?.didTapSearchButton()
    }
    
    @objc
    private func didTapNextButton() {
        delegate?.didTapNExtButton()
    }
}

private extension DeliveryView {
    func setupView() {
        backgroundColor = .carbon
        
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        addSubviews(titleLabel, searchButton, nextButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: searchButton.leadingAnchor, constant: -8),
            
            searchButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchButton.heightAnchor.constraint(equalToConstant: 17),
            searchButton.widthAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
