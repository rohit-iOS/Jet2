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
    @IBOutlet weak var deleteBtn: UIButton!
    var dataSource : [TeamMember]?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTeamMembersList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshListing(with feedData: [TeamMember]?) {
        dataSource = feedData
        membersListCollectionV.reloadData()
    }

    func fetchTeamMembersList() {
        
        APIManager.get(request: UrlComponents.feedUrlPartStr) { (success, dataResponse, isOffline)  in
            DispatchQueue.main.async {
                if success {
                    guard let data = dataResponse else {
                        print("Facing some data issue")
                        return
                    }
                    do {
                        let searchResult = try JSONDecoder().decode(TeamMembers.self, from: data)
                        self.refreshListing(with: searchResult.teamMebers)
                        self.storeDataForOffline()
                    }
                    catch {
                        print(error.localizedDescription)
                        print("Data parsing issue")
                    }
                } else {
                    print("Some network error.")
                    if isOffline {
                        if let savedMembers = self.defaults.object(forKey: "SavedMembers") as? Data {
                            let decoder = JSONDecoder()
                            if let loadedMemebers = try? decoder.decode([TeamMember].self, from: savedMembers) {
                                self.refreshListing(with: loadedMemebers)
                            }
                        }
                    }
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
    
    @IBAction func sortBtnAction(_ sender: UIButton) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "By last name", style: .default) { (action) in
            self.sortListing(by: .byLastName)
        }
        let saveAction = UIAlertAction(title: "By age", style: .default) { (action) in
            self.sortListing(by: .byAge)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    enum Sort {
        case byLastName
        case byAge
    }
    
    func sortListing(by sortType:Sort) {
        
        switch sortType {
        case .byLastName :
            let sortedDataSource = dataSource?.sorted(by: { (member1, member2) -> Bool in
                member1.name.lastName < member2.name.lastName
            })
            refreshListing(with: sortedDataSource)
            break
        case .byAge :
            let sortedDataSource = dataSource?.sorted(by: { (member1, member2) -> Bool in
                member1.dateOfBirth.date < member2.dateOfBirth.date
            })
            refreshListing(with: sortedDataSource)

            break
        }
    }
    
    @IBAction func deleteBtnAction(_ btn: UIButton) {
        func showDelete(show:Bool) {
            for item in membersListCollectionV!.visibleCells as! [MembersCollectionViewCell] {
                let indexPath: NSIndexPath = membersListCollectionV!.indexPath(for: item)! as NSIndexPath
                let cell: MembersCollectionViewCell = membersListCollectionV.cellForItem(at: indexPath as IndexPath) as! MembersCollectionViewCell
                cell.deleteBtn.isHidden = show
            }
        }

        if btn.titleLabel?.text == "Delete" {
            btn.setTitle("Done", for: .normal)
            showDelete(show: false)
        } else {
            btn.setTitle("Delete", for: .normal)
            showDelete(show: true)
        }
        storeDataForOffline()
    }
    
    @objc func deleteMemeberCell(btn:UIButton) {
        let i: Int = (btn.layer.value(forKey: "index")) as! Int
        dataSource!.remove(at: i)
        membersListCollectionV!.reloadData()
    }

    func storeDataForOffline() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dataSource) {
            defaults.set(encoded, forKey: "SavedMembers")
        }
    }
}


extension HomeFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MembersCollectionViewCell", for: indexPath) as! MembersCollectionViewCell
        
        cell.configureCell(with: dataSource![indexPath.row])
        
        if deleteBtn.titleLabel?.text == "Delete" {
            cell.deleteBtn.isHidden = true
        } else {
             cell.deleteBtn.isHidden = false
        }
        
        cell.deleteBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteBtn.addTarget(self, action: #selector(deleteMemeberCell(btn:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2 - 5, height: (collectionView.frame.width/2 + 50))
    }
}

extension HomeFeedViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueHomeFeedToDetails", sender: dataSource![indexPath.row])
    }
}
