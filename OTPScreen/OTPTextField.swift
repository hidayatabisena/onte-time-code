//
//  OTPTextField.swift
//  OTPScreen
//
//  Created by Hidayat Abisena on 15/02/23.
//

import UIKit

class OTPTextField: UITextField {
    
    // MARK: - PROPERTIES
    var didEnterLastDigit: ((String) -> Void)?
    
    private var isConfigured: Bool = false
    private var digitLabels = [UILabel]()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        
        return recognizer
    }()
    
    // MARK: - FUNCTION
    func configure(with digits: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: digits)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1...count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            // label.backgroundColor = .lightGray
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.gray.cgColor
            label.isUserInteractionEnabled = true
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc private func textDidChange() {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for textItem in 0..<digitLabels.count {
            let currentLabel = digitLabels[textItem]
            
            if textItem < text.count {
                let index = text.index(text.startIndex, offsetBy: textItem)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text?.removeAll()
            }
        }
        
        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }
}

// MARK: - EXTENSION
extension OTPTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
}
