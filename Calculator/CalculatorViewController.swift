//
//  ViewController.swift
//  Calculator
//
//  Created by Alikhan Khassen on 22.12.2020.f
//

import UIKit
import SnapKit


enum CalculatorButton: String {
    
    case ac = "AC", plusMinus =  "+/-", percent = "%"
    case equals = "=", plus = "+", minus = "–", multiply = "×", divide = "÷"
    case zero = "0", one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", dot = "."
    
    var backgroundColor: UIColor {
        switch self {
        case .ac, .plusMinus, .percent:
            return .lightGray
        case .equals, .plus, .minus, .multiply, .divide:
            return .orange
        default:
            return .darkGray
        }
    }
}


class CalculatorViewController: UIViewController {
    
    var calculator = Calculator()
    
    private var currentValue = 0
    private var performingOperation = false
    
    private var calculatorButtons: [[CalculatorButton]] = [[.ac, .plusMinus, .percent, .divide],
                                                           [.seven, .eight, .nine, .multiply],
                                                           [.four, .five, .six, .minus],
                                                           [.one, .two, .three, .plus],
                                                           [.zero, .dot, .equals]]
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 70, weight: .medium)
        
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let displayView: UIView = {
        let displayView = UIView()
        displayView.backgroundColor = .black
        return displayView
    }()
    
    private let buttonsView: UIView = {
        let view = UIView()
        view.backgroundColor = .black

        return view
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1.0
        stackView.distribution = .fillEqually
        
        for row in calculatorButtons {
            let buttonRowsStackView = UIStackView()
            buttonRowsStackView.axis = .horizontal
            buttonRowsStackView.distribution = .fillEqually
            buttonRowsStackView.spacing = 1.0
            
            for calculatorButton in row {
                let button = UIButton()
                
                button.backgroundColor = calculatorButton.backgroundColor
                button.setTitle(calculatorButton.rawValue, for: .normal)
                button.titleLabel?.font = .systemFont(ofSize: 25)
                
                button.addTarget(self, action: #selector(calculatorButtonDidPress), for: .touchUpInside)

                buttonRowsStackView.addArrangedSubview(button)
                
            }
            
            stackView.addArrangedSubview(buttonRowsStackView)
        }
    
        return stackView
    }()
    
    
    private func layoutUI() {
        configureLabel()
        configureContainerStackView()
        configureButtonsStackView()
    }
    
    private func configureLabel() {
        displayView.addSubview(displayLabel)
        
        displayLabel.snp.makeConstraints {
            $0.left.greaterThanOrEqualToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func configureContainerStackView() {
        
        containerStackView.addArrangedSubview(displayView)
        containerStackView.addArrangedSubview(buttonsView)
        view.addSubview(containerStackView)
        
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        buttonsView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.6)
            
        }
    }
    
    private func configureButtonsStackView() {
        buttonsView.addSubview(buttonsStackView)
        
        buttonsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
        
        
    }
    
    
    private func numberButtonDidPress(number: String) {
        if displayLabel.text != "0" && !performingOperation && !calculator.errorOccured {
            displayLabel.text! += number
        } else {
            displayLabel.text = number
            calculator.errorOccured = false
            performingOperation = false
        }
    }
    
    private func             clearButtonDidPress() {
        displayLabel.text = "0"
        calculator.errorOccured = false
    }
    
    private func changeSignButtonDidPress() {
        if (calculator.errorOccured) { return }
        if Double(displayLabel.text!)! <= 0 {
            displayLabel.text = "\(abs(Double(displayLabel.text!)!).cleanString)"
        } else {
            displayLabel.text = "-\(displayLabel.text!)"
        }
    }
    
    private func unaryOperationButtonDidPress(operation: String) {
        if (calculator.errorOccured) { return }
        calculator.currentValue = Double(displayLabel.text!)!
        calculator.currentOperation = calculator.operations[operation]!
        displayLabel.text = "\(calculator.getResult())"
        calculator.currentOperation = .none
    }
    
    private func decimalPointButtonDidPress() {
        if (calculator.errorOccured) { return }
        displayLabel.text = (displayLabel.text?.contains("."))! ? displayLabel.text : displayLabel.text! + "."
    }
    
    private func binaryOperationButtonDidPress(operation: String) {
        if (calculator.errorOccured) { return }
        calculator.savedValue = Double(String(displayLabel.text!))!
        calculator.currentOperation = calculator.operations[operation]!
        performingOperation = true
    }
    
    private func equalsButtonDidPress() {
        if (calculator.errorOccured) || calculator.currentOperation == .none { return }
        calculator.currentValue = Double(displayLabel.text!)!
        displayLabel.text = calculator.getResult()
        calculator.currentOperation = .none
    }
    
    @objc private func calculatorButtonDidPress(sender: UIButton) {
        
        guard let buttonText = sender.titleLabel?.text else { return }
        
        switch buttonText {
        case "AC":
            clearButtonDidPress()
        case "+/-":
            changeSignButtonDidPress()
        case "%":
            unaryOperationButtonDidPress(operation: buttonText)
        case ".":
            decimalPointButtonDidPress()
        case "+", "–", "×", "÷":
            binaryOperationButtonDidPress(operation: buttonText)
        case "=":
            equalsButtonDidPress()
        default:
            numberButtonDidPress(number: buttonText)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        layoutUI()
    }


}


