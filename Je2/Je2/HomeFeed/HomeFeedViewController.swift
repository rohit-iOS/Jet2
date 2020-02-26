//
//  HomeFeedViewController.swift
//  Je2
//
//  Created by Rohit Karyappa on 2/26/20.
//  Copyright © 2020 Rohit Karyappa. All rights reserved.
//

import UIKit

class HomeFeedViewController: UIViewController {
    
    @IBOutlet weak var membersListCollectionV: UICollectionView!
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
        membersListCollectionV.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueHomeFeedToDetails" {
            let destinationVC = segue.destination as! MemebrDetailsViewController
            destinationVC.memberInformation = (sender as! TeamMember)
            
        }
    }
}


extension HomeFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.teamMebers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MembersCollectionViewCell", for: indexPath) as! MembersCollectionViewCell
        
        cell.configureCell(with: dataSource!.teamMebers[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5, height: (collectionView.frame.width/2 + 50))
    }
}

extension HomeFeedViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueHomeFeedToDetails", sender: dataSource!.teamMebers[indexPath.row])
    }
}
