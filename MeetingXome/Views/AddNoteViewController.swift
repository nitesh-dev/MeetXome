//
//  AddNoteViewController.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddNoteViewController: UIViewController {

    @IBOutlet weak var meetingTitle: UITextField!
    @IBOutlet weak var meetingDate: UITextField!
    @IBOutlet weak var meetingDatePicker: UIDatePicker!
    @IBOutlet weak var meetingNotes: UITextView!
    @IBOutlet weak var meetingAuthor: CustomTextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editNoteButton: UIBarButtonItem!
    @IBOutlet weak var pickerContainerView: UIView!
    
    private var addNoteViewModel = AddNoteViewModel()
    private var meetingViewModel = MeetingListViewModel()
    var editMeetingData: Meeting!
    private let currentUserName = Auth.auth().currentUser?.displayName
    private let currentUserID = Auth.auth().currentUser?.uid
    
    @IBAction func makeNoteEditable(_ sender: UIBarButtonItem) {
        addButton.setTitle("Edit Note", for: .normal)
        meetingTitle.isEnabled = true
        meetingNotes.isEditable = true
        meetingDate.isEnabled = true
        addButton.isEnabled = true
    }
    
    @IBAction func addNote(_ sender: UIButton) {
        switch addNoteViewModel.validateMeetingForm() {
        case .valid:
            if editMeetingData != nil {
                addNoteViewModel.editMeetingNote(editedMeeting: editMeetingData, completionHandler: {
                    state in
                    switch state {
                    case .success:
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        AlertHelper.showErrorMessage(vc: self, title: error.localizedDescription)
                    }
                })
            }
            else {
                addNoteViewModel.addMeetingNoteToFirebaseAndUpdateLocal(completionHandler: {
                    state in
                    switch state {
                    case .success:
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        AlertHelper.showErrorMessage(vc: self, title: error.localizedDescription)
                    }
                })
            }
        case .invalid(let error):
            AlertHelper.showErrorMessage(vc: self, title: error.description)
        }
    }
    
    @IBAction func pickDate(_ sender: UITextField) {
        meetingDatePicker.datePickerMode = .dateAndTime
        meetingDatePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerContainerView.isHidden = !self.pickerContainerView.isHidden
            self.meetingDatePicker.isHidden = !self.meetingDatePicker.isHidden
        })
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        self.meetingDatePicker.maximumDate = Date()
        meetingDate.text = dateFormatter.string(from: sender.date)
        addNoteViewModel.updateDate(date: meetingDate.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerContainerView.isHidden = true
        self.meetingDatePicker.isHidden = true
        self.meetingAuthor.text = currentUserName
        self.meetingAuthor.isEnabled = false
        
        if editMeetingData != nil {
            addNoteViewModel.updateTitle(title: editMeetingData.meetingTitle)
            addNoteViewModel.updateDate(date: editMeetingData.meetingDate)
            addNoteViewModel.updateNotes(notes: editMeetingData.meetingNotes)
            
            meetingTitle.text = editMeetingData.meetingTitle
            meetingDate.text = editMeetingData.meetingDate
            meetingNotes.text = editMeetingData.meetingNotes
            addButton.setTitle("Note Added", for: .normal)
            
            meetingTitle.isEnabled = false
            meetingNotes.isEditable = false
            meetingDate.isEnabled = false
            addButton.isEnabled = false
        }
        else {
            editNoteButton.isEnabled = false
            meetingNotes.text = "Add Meeting Note"
            meetingNotes.textColor = UIColor.lightGray
        }
        meetingTitle.delegate = self
        meetingDate.delegate = self
        meetingNotes.delegate = self
        
        addNoteViewModel.meetingTitle.bindAndFire {
            print($0)
        }
        addNoteViewModel.meetingDate.bindAndFire {
            print($0)
        }
        addNoteViewModel.meetingNotes.bindAndFire {
            print($0)
        }
    }
}

extension AddNoteViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == meetingTitle {
            textField.text = addNoteViewModel.meetingTitle.value
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == meetingTitle {
            addNoteViewModel.updateTitle(title: newString)
        }
        if textField == meetingDate {
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if textView == meetingNotes {
            textView.text = addNoteViewModel.meetingNotes.value
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = (textView.text! as NSString).replacingCharacters(in: range, with: text)
        if textView == meetingNotes {
            addNoteViewModel.updateNotes(notes: newString)
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Meeting Note"
            textView.textColor = UIColor.lightGray
        }
    }
}
