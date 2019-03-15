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
import Moya
import ObjectMapper
import Moya_ObjectMapper

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
    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var teams: [TeamModel]!
    var error: ErrorModel?
    var searchButtonObserver: Signal<String, NoError>.Observer?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.gray.cgColor
        setButtonAction()
        errorLabel.isHidden = true
    }
    
    func setErrorAction() {
        if (error == nil) {
            errorLabel.isHidden = true
            return;
        }
        errorLabel.text = error?.description
        if (errorLabel.text?.count ?? 0 > 0 && errorLabel.text != "Error") {
            errorLabel.isHidden = false
        }
        else {
            errorLabel.isHidden = true
        }
    }
    
    func setButtonAction() {
        let emailTextFieldSignal = emailTextField.reactive.continuousTextValues
        let validator = emailTextFieldSignal
            .map { email in
                return email!.isValidEmail()
        }
        let enabledIf = Property(initial: false, then: validator)
        let action = Action<String, String, NoError>(enabledIf: enabledIf) { email in
            return SignalProducer<String, NoError> { observer, disposable in
                self.searchButtonObserver = observer
                observer.send(value: email)
            }
        }
        action.values.observeValues {
            email in
            if email.isValidEmail() {
                self.sendRequest(email: email)
            } else {
                print("Wrong email")
            }
        }
        searchButton.reactive.pressed = CocoaAction<UIButton>(action){_ in self.emailTextField.text!}
    }
    
    func sendRequest(email: String) {
        let provider = MoyaProvider<PandalabApiProviderService>()
        provider.reactive.request(.getUserTeams(email: email))
            .filterSuccessfulStatusCodes()
            .mapArray(TeamModel.self)
            .start { event in
                switch event {
                case .value(let teams):
                    self.error = nil
                    self.teams = teams
                    self.performSegue(withIdentifier: "mainToTeamView", sender: self)
                case .failed(let error):
                    do {
                        if let errorString = try error.response?.mapString() {
                            self.error = Mapper<ErrorModel>().map(JSONString: errorString)
                        }
                        self.setErrorAction()
                    } catch {
                        self.error = ErrorModel()
                    }
                default: break
                }
                self.setErrorAction()
                self.searchButtonObserver!.sendCompleted()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let teamView = segue.destination as? TeamViewController else {return}
        teamView.teams = self.teams
        teamView.email = self.emailTextField.text
    }

}


