//
//  Model.swift
//  calculator
//
//  Created by chikuma on 2020/5/4.
//  Copyright © 2020 簡少澤. All rights reserved.
//

import Foundation

enum OpError: Error {
    case IllegalOperationError
}

class Model {
    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }
    
    func formatInputValue() -> String{
        if (input.count > 10) {
            let index10 = input.index(input.startIndex, offsetBy: 10)
            input = String(input.prefix(upTo: index10))
        }
        
        let formatted = Double(input) ?? 0
        var output: String = String(formatted)
        
        if (formatted == Double(Int(formatted))) {
            output = String(Int(formatted))
        }
        
        return output
    }
    
    func getInputValue() -> String {
        return input
    }
    
    func getEquation() -> String {
        if (input == "0" && lhs == "0" && rhs == nil && op == nil) {
            return ""   // AC
        }
        return "\(lhs) \(op ?? "") \(rhs ?? "") ="
    }
    
    func getPosNeg() -> String {
        return "±(" + input + ") ="
    }
        
    func appendNumToInput(number: String) {
        if (input.contains(".") && number == ".") { return }
        if (input == "0" && number != ".") {input = ""}
        input += number
    }
    
    func triggerOpeartor(op: String) {
        self.op = op
        lhs = formatInputValue()
        input = "0"
        notificationCenter.post(name: .equationUpdated, object: nil)
    }
    
    func ac() {
        input = "0"
        lhs = "0"
        rhs = nil
        op = nil
        notificationCenter.post(name: .equationUpdated, object: nil)
    }
    
    func calculate() throws {
        rhs = formatInputValue()
        let lparam: Double = Double(lhs) ?? 0
        let rparam: Double = Double(rhs!) ?? 0
        var result: Double = 0
        
        print("lhs \(lparam) rhs \(rparam)")
        
        if (op == "+") {result = lparam + rparam}
        else if (op == "-") { result = lparam - rparam }
        else if (op == "*") { result = lparam * rparam }
        else if (op == "/") {
            if (rparam == 0) { result = 0 }
            else { result = lparam / rparam }
        }
        else {throw OpError.IllegalOperationError}
        
        input = String(result)              // updated inputLabel twice :(
        input = formatInputValue()          // notify input and equation labels
        notificationCenter.post(name: .equationUpdated, object: nil)
        
        rhs = nil                           // clear rhs for pressing "=" again
    }
    
    func posNeg() {
        input = String((Double(input) ?? 0) * -1)
        input = formatInputValue()
        // update view directly B-)
    }
    
    func percentage() {
        input = String((Double(input) ?? 0) * 0.01)
    }
    
    private var input: String = "0" {
        didSet {
            print("Value now: \(input)")
            notificationCenter.post(name: .inputUpdated, object: nil)
        }
    }
    private var lhs: String = "0"
    private var rhs: String? = nil
    private var op: String? = nil
    private let notificationCenter: NotificationCenter
}

extension Notification.Name {
    static var inputUpdated: Notification.Name {
        return .init(rawValue: "model.inputUpdated")
    }
    static var equationUpdated: Notification.Name {
        return .init(rawValue: "model.equationUpdated")
    }
    static var posNegChanged: Notification.Name {
        return .init(rawValue: "model.posNegChanged")
    }
}

