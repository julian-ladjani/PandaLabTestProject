//
//  TeamViewController.swift
//  PandaLabTestProject
//
//  Created by julian ladjani on 15/03/2019.
//  Copyright © 2019 julian ladjani. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController {
    
    @IBOutlet weak var teamsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var teams: [TeamModel]!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        titleLabel.text = "Teams of \"\(email ?? "unknown mail")\":"
    }

}

extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        cell.textLabel!.text = teams[indexPath.row].name
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams!.count
    }
    
}
