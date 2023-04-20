import UIKit

// MARK: - Label

class Label: UILabel {
    
    private(set) var textLabelColor: UIColor? = .black
    private(set) var textLabelFont: UIFont? = .systemFont(ofSize: 14, weight: .regular)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
}

// MARK: - Private methods

private extension Label {
    func setupLabel() {
        font = textLabelFont
        textColor = textLabelColor
    }
}
