//
//  HomeViewController.swift
//  MeetingXome
//
//  Created by Nitesh Singh # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var meetingTableView: UITableView!
    private var meetingViewModel = MeetingListViewModel()
    private var meetingList: [Meeting] = []
    let userID = Auth.auth().currentUser?.uid
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: AppConstants.Controller.loginViewController) as! LoginViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetingViewModel.fetchMeetingsFromFirebase(completionHandler: { (state) in
            switch state {
            case .success(let meetings):
                self.meetingList = meetings
                self.meetingTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
               
            }
        })
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Cells.MeetingCell, for: indexPath)
        if meetingList.count > 0
        {
            cell.textLabel?.text =  meetingList[indexPath.row].meetingTitle
            cell.detailTextLabel?.text = meetingList[indexPath.row].meetingDate
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meeting = meetingList[indexPath.row]
        let editMeetingVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.addNoteViewController) as! AddNoteViewController
        editMeetingVC.editMeetingData = meeting
        self.navigationController?.pushViewController(editMeetingVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let meetingDocID = meetingList[indexPath.row].meetingDocID
            meetingViewModel.deleteNoteFromFirebase(userID: self.userID!, documentID: meetingDocID, completionHandler: { state in
                
            })
        }
    }
}
