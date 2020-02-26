//
//  HomeFeedViewController.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import UIKit

class HomeFeedViewController: UIViewController {
    
    var dataSource : TeamMembers?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTeamMembersList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshListing(with feedData: TeamMembers?) {
        dataSource = feedData
        // reload listing
    }

    func fetchTeamMembersList() {
        
        APIManager.get(request: UrlComponents.feedUrlPartStr) { (success, dataResponse) in
            DispatchQueue.main.async {
                if success {
                    guard let data = dataResponse else {
                        print("Facing some data issue")
                        return
                    }
                    do {
                        let searchResult = try JSONDecoder().decode(TeamMembers.self, from: data)
                        self.refreshListing(with: searchResult)
                    }
                    catch {
                        print(error.localizedDescription)
                        print("Data parsing issue")
                    }
                } else {
                    print("Some network error.")
                }
            }
        }
    }
}
