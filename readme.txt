Contributions:

Regina Chen (23%)
- Calendar screen using FSCalendar
- Extended day screen that fetches the date selected
- Added MoodleColors class to fetch color by rating

Tony Chang (31%)
- Defined Core Data model for how app will store each day’s Entry for users (moodle.xcdatamodel)
- Created Core Data interface for storing, editing, retrieving entries, and a Mock class that utilizes the Entry interface to generate fake data for testing (Data.swift)
- Integrated all group member’s individual storyboards files and view controllers into Main.storyboard for functional app with functional navigation (different storyboard files from each member -> Main.storyboard)
- Built out the not-yet-functional settings view controller and basic idea of visualizations view controller, present  basic visualizations that pull from CoreData (SettingsViewController.swift & VisualizationsViewController.swift)

Jessica Ma (23%)
- Login screen with connection to Firebase
- Added sign in screen with ability to sign up from the app itself, adding the entry to Firebase
- Created sign out button that pulls up the initial login screen again

Francis Tran (23%)
- Created two screens for users to input data.
- Added photo selection and camera usage

Deviations:
- Have not yet implemented splash/loading screen yet because have not decided logo (we are not concerned about this because it should take a few minutes maximum)
- The settings and visualizations view controllers are part of our beta release, not alpha, so this part is not yet completely done but we had free worktime so we wanted to share this as well.
