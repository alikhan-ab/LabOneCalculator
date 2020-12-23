//
//  ViewController.swift
//  LabOneCalculator
//
//  Created by Alikhan Abutalipov on 12/17/20.
//

import SnapKit

class OperationButton: UIButton {
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? ViewController.pureWhite : ViewController.orange
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
    static let lightGray = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
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
    private var numberButtons: [UIButton] = []
    private let periodButton = makeButton(for: ",", selectedTitle: nil, backgroundColor: darkGray, titleColorForNormal: numberWhite, titleColorForSelected: nil, cornerRadius: 35)
    
    // Operation buttons
    private let divisionButton = makeOperationButton(for: "÷")
    private let multiplicationButton = makeOperationButton(for: "×")
    private let subtracktionButton = makeOperationButton(for: "–")
    private let additionButton = makeOperationButton(for: "+")
    private let resultButton = makeOperationButton(for: "=")
    
    // Additional method buttons
    private let cancelButton = makeButton(for: "AC", selectedTitle: "C", backgroundColor: lightGray, titleColorForNormal: symbolBlack, titleColorForSelected: nil, cornerRadius: 35)
    private let plusMinusButton = makeButton(for: "+/-", selectedTitle: nil, backgroundColor: lightGray, titleColorForNormal: symbolBlack, titleColorForSelected: nil, cornerRadius: 35)
    private let percentButton = makeButton(for: "%", selectedTitle: nil, backgroundColor: lightGray, titleColorForNormal: symbolBlack,titleColorForSelected: nil, cornerRadius: 35)
    
    
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        return stackView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layoutUI()
    }
    
    // MARK: - Configure Layout
    // TODO: - Make the zero be twice as much as two buttons
    // TODO: - Make scaling of spacings for different screen sizes
    
    private func layoutUI() {
        createNumberButtons()
        configureResultLabel()
        configureButtonsStack()
        
    }
    
    private func createNumberButtons() {
        for number in 0...9 {
            let button = ViewController.makeButton(for: "\(number)", selectedTitle: nil, backgroundColor: ViewController.darkGray, titleColorForNormal: ViewController.numberWhite, titleColorForSelected: nil, cornerRadius: 35)
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
            
//            $0.right.equalToSuperview().offset(-10)
//            $0.left.equalToSuperview().offset(10)
            
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(10)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-10)

            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
        
        
        
        // First row
        
        cancelButton.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        plusMinusButton.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        percentButton.addTarget(self, action: #selector(methodButtonDidPress(_:)), for: .touchUpInside)
        divisionButton.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
        
        cancelButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        plusMinusButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        percentButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        divisionButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        
        let firstRowStack = makeRowStackView(arrangedSubviews: [cancelButton, plusMinusButton, percentButton, divisionButton])
        
        
        // Second row
        
        numberButtons[7].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        numberButtons[8].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        numberButtons[9].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        multiplicationButton.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
        
        
        numberButtons[7].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        numberButtons[8].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        numberButtons[9].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        multiplicationButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        
        let secondRowStack = makeRowStackView(arrangedSubviews: [numberButtons[7], numberButtons[8], numberButtons[9], multiplicationButton])
//        secondRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Third row
        
        numberButtons[4].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        numberButtons[5].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        numberButtons[6].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        subtracktionButton.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
        
        
        numberButtons[4].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        numberButtons[5].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        numberButtons[6].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        subtracktionButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        
        let thirdRowStack = makeRowStackView(arrangedSubviews: [numberButtons[4], numberButtons[5], numberButtons[6], subtracktionButton])
        
        
        // Fourth row
        
        numberButtons[1].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        numberButtons[2].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        numberButtons[3].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        additionButton.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
        
        
        numberButtons[1].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        numberButtons[2].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        numberButtons[3].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        additionButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        
        let fourthRowStack = makeRowStackView(arrangedSubviews: [numberButtons[1], numberButtons[2], numberButtons[3], additionButton])
        
        
        // Fifth row
        
        numberButtons[0].addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        periodButton.addTarget(self, action: #selector(inputButtonDidPress(_:)), for: .touchUpInside)
        resultButton.addTarget(self, action: #selector(operationButtonDidPress(_:)), for: .touchUpInside)
        
        numberButtons[0].snp.makeConstraints({
            $0.size.equalTo(70)
        })
        periodButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        resultButton.snp.makeConstraints({
            $0.size.equalTo(70)
        })
        
        let fifthRowStack = makeRowStackView(arrangedSubviews: [numberButtons[0], periodButton, resultButton])
        


        
        
        mainStackView.addArrangedSubview(firstRowStack)
        mainStackView.addArrangedSubview(secondRowStack)
        mainStackView.addArrangedSubview(thirdRowStack)
        mainStackView.addArrangedSubview(fourthRowStack)
        mainStackView.addArrangedSubview(fifthRowStack)
        
        
    }
    

    // MARK: - User interaction
    
    
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
            currentInput?.negate()
        case percentButton:
            
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
                currentInput?.isDecimalMode = true
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
        button.layer.cornerRadius = 35
        
        
        return button
    }
    
    
    private static func makeButton(for title: String, selectedTitle: String?, backgroundColor: UIColor, titleColorForNormal: UIColor, titleColorForSelected: UIColor?, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        button.setTitle(selectedTitle, for: .selected)
        button.setTitleColor(titleColorForNormal, for: .normal)
        button.setTitleColor(titleColorForSelected, for: .selected)
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        return button
    }
        
    private func makeRowStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    
    //
    
    private func isEnoughPlaceForInput() -> Bool {
        
        guard let digitsCount = currentInput?.countDigits() else { return true }
        
        return digitsCount == 9 ? false : true
    }
    
    private func displayCurrentInput() {
        if let description = currentInput?.description {
            resultLabel.text = description
        } else {
            resultLabel.text = "0"
        }
    }
}

