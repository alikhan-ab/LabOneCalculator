//
//  ViewController.swift
//  LabOneCalculator
//
//  Created by Alikhan Abutalipov on 12/17/20.
//

import SnapKit

class RoundButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}

class OperationButton: RoundButton {
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? ViewController.pureWhite : ViewController.orange
        }
    }
}

class MethodButton: RoundButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? ViewController.highlightedLightGray : ViewController.lightGray
        }
    }
}

class InputButton: RoundButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? ViewController.highlightedDarkGray : ViewController.darkGray
        }
    }
    
}

class ViewController: UIViewController {
    
    // TODO: - Create a custom button class for highlighted buttons

    
    enum Operation {
        case none
        case addition
        case subtraction
        case multiplicaiton
        case division
        case result
    }
    

    private var currentOperation: Operation = .none
    private var isDecimal = false
    private var currentDecimalPlace = 0
    private var currentInput: Input?
    private var previousInput: Input?
    private var didUserEnterInput = false
    
    
    // MARK: - Color constants
    
    static let numberWhite = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
    static let symbolBlack = #colorLiteral(red: 0.09803921569, green: 0.09803921569, blue: 0.09803921569, alpha: 1)
    static let darkGray = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let highlightedDarkGray = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
    static let lightGray = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
    static let highlightedLightGray = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    static let orange = #colorLiteral(red: 0.9882352941, green: 0.6235294118, blue: 0.168627451, alpha: 1)
    static let pureWhite = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)


    // MARK: - UI Element properties
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 100, weight: .thin)
        label.text = "0"
        return label
    }()
    
    // Number buttons
    private var numberButtons: [InputButton] = []
    private let periodButton = makeInputButton(for: ",")
    
    // Operation buttons
    private let divisionButton = makeOperationButton(for: "÷")
    private let multiplicationButton = makeOperationButton(for: "×")
    private let subtracktionButton = makeOperationButton(for: "–")
    private let additionButton = makeOperationButton(for: "+")
    private let resultButton = makeOperationButton(for: "=")
    
    // Additional method buttons
    private let cancelButton = makeMethodButton(for: "AC", selectedTitle: "C")
    private let plusMinusButton = makeMethodButton(for: "+/-", selectedTitle: nil)
    private let percentButton = makeMethodButton(for: "%", selectedTitle: nil)
    
    
    
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    
    
    // MARK: - Class Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layoutUI()
        configureUserInteraction()
    }
    
    // MARK: - Configure Layout
    
    private func layoutUI() {
        createNumberButtons()
        configureResultLabel()
        configureButtonsStack()
    }
    
    private func createNumberButtons() {
        for number in 0...9 {
            let button = ViewController.makeInputButton(for: "\(number)")
            numberButtons.append(button)
        }
    }
    
    private func configureResultLabel() {
        view.addSubview(resultLabel)
        
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 10 / 85
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.bottom).multipliedBy(Float(1)/Float(6))
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    private func configureButtonsStack() {
        
        // Main stack
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints{
            $0.top.equalTo(resultLabel.snp.bottom).offset(10)
        
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)

            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        
        let firstRowStack = makeRowStackView(arrangedSubviews: [cancelButton, plusMinusButton, percentButton, divisionButton])
        
        let secondRowStack = makeRowStackView(arrangedSubviews: [numberButtons[7], numberButtons[8], numberButtons[9], multiplicationButton])
        
        let thirdRowStack = makeRowStackView(arrangedSubviews: [numberButtons[4], numberButtons[5], numberButtons[6], subtracktionButton])

        let fourthRowStack = makeRowStackView(arrangedSubviews: [numberButtons[1], numberButtons[2], numberButtons[3], additionButton])
        
        let fifthRowRightStack = makeRowStackView(arrangedSubviews: [periodButton, resultButton])
        let fifthRowStack = makeRowStackView(arrangedSubviews: [numberButtons[0], fifthRowRightStack])
        

        mainStackView.addArrangedSubview(firstRowStack)
        mainStackView.addArrangedSubview(secondRowStack)
        mainStackView.addArrangedSubview(thirdRowStack)
        mainStackView.addArrangedSubview(fourthRowStack)
        mainStackView.addArrangedSubview(fifthRowStack)
        
       
        // Buttons constraints
        // First row
        cancelButton.snp.makeConstraints({
            $0.height.equalTo(cancelButton.snp.width)
        })
        plusMinusButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        percentButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        divisionButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        
        // Second row
        numberButtons[7].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        numberButtons[8].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        numberButtons[9].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        multiplicationButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        
        // Third row
        numberButtons[4].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        numberButtons[5].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        numberButtons[6].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        subtracktionButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        
        // Forth row
        numberButtons[1].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        numberButtons[2].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        numberButtons[3].snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        additionButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        
        // Fifth row
        periodButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        resultButton.snp.makeConstraints({
            $0.size.equalTo(cancelButton.snp.size)
        })
        
        // Zero button
        numberButtons[0].snp.makeConstraints({
            $0.height.equalTo(cancelButton.snp.height)
        })
        
        
    }
    

    // MARK: - User interaction
    
    private func configureUserInteraction() {
        for button in [cancelButton, plusMinusButton, percentButton] {
            button.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        }
        
        for button in numberButtons {
            button.addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        }
        periodButton.addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        
        for button in [divisionButton, multiplicationButton, subtracktionButton, additionButton, resultButton] {
            button.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
        }
        
        cancelButton.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        plusMinusButton.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        percentButton.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        divisionButton.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
    }
    
    
    @objc private func methodButtonDidPress(_ sender : UIButton) {
        
        
        switch sender {
        case cancelButton:
            
            // Delete the current input
            currentInput = nil
            isDecimal = false
            didUserEnterInput = false
            
            if cancelButton.isSelected {
                cancelButton.isSelected = false
            } else {
                unselectOperation()
                previousInput = nil
            }
            
        case plusMinusButton:
            
            if currentInput != nil {
                currentInput?.negate()
            } else {
                currentInput = .zero
                didUserEnterInput = true
                currentInput?.negate()
            }
            
        case percentButton:
            
            currentInput = currentInput.
            
            break;
        default:
            break
        }
        
        displayCurrentInput()
        
        print("\(String(describing: sender.title(for: .normal))) did press ")
    
    }

    @objc private func operationButtonDidPress(_ sender : UIButton) {
        
        if currentOperation == .none {
            previousInput = currentInput
            didUserEnterInput = false
        }
        
        // Unselect previously selected operation
        unselectOperation()
  
        // Select newly pressed operation
        switch sender {
        case additionButton:
            additionButton.isSelected = true
            currentOperation = .addition
        case subtracktionButton:
            subtracktionButton.isSelected = true
            currentOperation = .subtraction
        case multiplicationButton:
            multiplicationButton.isSelected = true
            currentOperation = .multiplicaiton
        case divisionButton:
            divisionButton.isSelected = true
            currentOperation = .division
            
        case resultButton:
            
            
            break
        default:
            break
        }
        
        
        print("\(String(describing: sender.title(for: .normal))) did press ")
        print("Current input: \(String(describing: currentInput)) Previous Input: \(String(describing: previousInput))")
        
    }
    
    @objc private func inputButtonDidPress(_ sender : UIButton) {
        
        cancelButton.isSelected = true
        
        guard isEnoughPlaceForInput() else { return }
        
        if !didUserEnterInput {
            currentInput = .zero
            didUserEnterInput = true
        }
        
        switch sender {
        case periodButton:
            if !isDecimal {
                isDecimal = true
                currentInput?.enterDecimalMode()
            }
            
        default:
            if !isDecimal {
                currentInput?.append(integer: Int(sender.title(for: .normal)!)!)
            } else {
                currentInput?.append(nonInteger: Int(sender.title(for: .normal)!)!)
            }
        }
        
        displayCurrentInput()
    }
    
    
    // MARK: -
    
    private func calculateResult() {
        didUserEnterInput = false
        
        
        
        
        
    }

    
    // MARK: - Helpers
    
    private func unselectOperation() {
        
        switch currentOperation {
        case .addition:
            additionButton.isSelected = false
        case .division:
            divisionButton.isSelected = false
        case .multiplicaiton:
            multiplicationButton.isSelected = false
        case .subtraction:
            subtracktionButton.isSelected = false
        default:
            break
        }
        
        currentOperation = .none
    }
    
    // UI helpers
    private static func makeOperationButton(for operation: String) -> OperationButton {
        let button = OperationButton()
        button.backgroundColor = orange
        button.setTitle(operation, for: .normal)
        button.setTitleColor(pureWhite, for: .normal)
        button.setTitleColor(orange, for: .selected)
        return button
    }
    
    
    private static func makeInputButton(for title: String) -> InputButton {
        let button = InputButton()
        button.backgroundColor = darkGray
        button.setTitle(title, for: .normal)
        button.setTitleColor(pureWhite, for: .normal)
        return button
    }
    
    private static func makeMethodButton(for title: String, selectedTitle: String?) -> MethodButton {
        let button = MethodButton()
        button.backgroundColor = lightGray
        button.setTitle(title, for: .normal)
        button.setTitle(selectedTitle, for: .selected)
        button.setTitleColor(symbolBlack, for: .normal)
        return button
    }
    
    private static func makeButton(for title: String, selectedTitle: String?, backgroundColor: UIColor, titleColorForNormal: UIColor, titleColorForSelected: UIColor?) -> RoundButton {
        let button = RoundButton()
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.setTitle(selectedTitle, for: .selected)
        button.setTitleColor(titleColorForNormal, for: .normal)
        button.setTitleColor(titleColorForSelected, for: .selected)
        return button
    }
        
    private func makeRowStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        return stackView
    }
    
    private func displayCurrentInput() {
        if let description = currentInput?.description {
            resultLabel.text = description
        } else {
            resultLabel.text = "0"
        }
    }
    
    
    
    // MARK: -
    private func isEnoughPlaceForInput() -> Bool {
        
        guard let digitsCount = currentInput?.countDigits() else { return true }
        
        return digitsCount == 9 ? false : true
    }
}
