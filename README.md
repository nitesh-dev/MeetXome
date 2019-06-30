# MeetXome
App to track meeting notes


Application to track meeting notes.

Language Used: Swift 4.0
Networking/ Persistence Used: Firebase
Architecture/ Design Pattern Used: Model View View-Model with Firebase Network Services mostly in ViewModels

Tests done on ViewModels Only with high unit test coverage.

Flow of Application:

Login/ Registration Screen: Can enter any email as of now (does not check validity of email as long as it's formatted correctly). Email address and passwords should be at least 5 characters long.

Home Screen: TableView consisting of list of meetings created by user. Has 'Log out' button for logging out and '+' button for adding a new meeting on navigation bar.

When '+' button is clicked, new screen to add note opens up. 

Add/ Edit Note Screen: '+' button opens up Add Note Screen. When clicked on cell, same screen opens up but with editable fields.
To edit, user must click edit icon on top right on navigation bar. Then user would be able to edit.

After editing or creating note, user must save note, which would instantly create/ edit note as well as update current list in tableview as application is listening for changes to particular collection.

Notes can be deleted also by sliding a cell to the left. As soon as note is deleted, tableview is reloaded (not completely though) only by deleteRows() method. This in turn deletes document from Firebase too.

As of now, only ViewModels are tested as they contained all of application logic and current coverage hovers around 40-45% with view models coverage around 85%.
