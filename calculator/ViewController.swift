//
//  ViewController.swift
//  calculator
//
//  Created by chikuma on 2020/5/4.
//  Copyright © 2020 簡少澤. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationCenter.addObserver(
            self,
            selector: #selector(updateInputLabel),
            name: .inputUpdated,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(updateEquationLabel),
            name: .equationUpdated,
            object: nil
        )
    }
    
    @objc private func updateInputLabel(_ notification: Notification) {
        inputLabel.text = model.getInputValue()
    }
    
    @objc private func updateEquationLabel(_ notification: Notification) {
        equationLabel.text = model.getEquation()
    }

    private var model: Model = Model()
    private var notificationCenter: NotificationCenter = .default
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet var numberButton: [UIButton]!
    
    @IBAction func pressNumberButton(_ sender: UIButton) {
        let number: String = String(numberButton.firstIndex(of: sender) ?? -1)
        print("\(number) button is pressed")
        model.appendNumToInput(number: String(number))
    }
    
    @IBAction func pressDecimalButton(_ sender: Any) {
        print(". is pressed")
        model.appendNumToInput(number: ".")
    }
    
    @IBAction func pressACButton(_ sender: Any) {
        model.ac()
    }
    
    @IBAction func pressPlusButton(_ sender: Any) {
        model.triggerOpeartor(op: "+")
    }
    
    @IBAction func pressMinusButton(_ sender: Any) {
        model.triggerOpeartor(op: "-")
    }
    
    @IBAction func pressMultiButton(_ sender: Any) {
        model.triggerOpeartor(op: "*")
    }
    
    @IBAction func pressDivButton(_ sender: Any) {
        model.triggerOpeartor(op: "/")
    }
    
    @IBAction func pressCalculateButton(_ sender: Any) {
        do {
            try model.calculate()
        } catch OpError.IllegalOperationError {
            print("Use of an illegal operator")
        } catch {
            print("Some other error occured")
        }
    }
    
    @IBAction func pressPosNegButton(_ sender: Any) {
        model.posNeg()
        equationLabel.text = model.getPosNeg()
    }
    
    @IBAction func pressPercentageButton(_ sender: Any) {
        model.percentage()
    }
}

