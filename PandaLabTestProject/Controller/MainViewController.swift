//
//  ViewController.swift
//  PandaLabTestProject
//
//  Created by julian ladjani on 14/03/2019.
//  Copyright © 2019 julian ladjani. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

class MainViewController: UIViewController {

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.gray.cgColor
        let emailTextFieldSignal = emailTextField.reactive.continuousTextValues
        let validator = emailTextFieldSignal
            .map { email in
                return email!.isValidEmail()
        }
        let enabledIf = Property(initial: false, then: validator)
        let action = Action<String, Bool, NoError>(enabledIf: enabledIf) { email in
            return SignalProducer<Bool, NoError> { observer, disposable in
                observer.send(value: true)
                observer.sendCompleted()
            }
        }
        action.values.observeValues {
            success in
            if success {
                print("Successfully sign in.")
            }
        }
        searchButton.reactive.pressed = CocoaAction(action, input: emailTextField.text!)
    }

}


