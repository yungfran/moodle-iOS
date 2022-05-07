Contributions:

Regina Chen (beta 25%, overall 24%)
--- ALPHA ---
- Calendar screen using FSCalendar
- Extended day screen that fetches the date selected
- Added MoodleColors class to fetch color by rating
--- BETA ---
- Update calendar view to fetch entries and display the rating color of each day
- Improved extended day view to display the rating and logs (text and photo) of each day

Tony Chang (beta 25%, overall 28%)
--- ALPHA ---
- Defined Core Data model for how app will store each day’s Entry for users (moodle.xcdatamodel)
- Created Core Data interface for storing, editing, retrieving entries, and a Mock class that utilizes the Entry interface to generate fake data for testing (Data.swift)
- Integrated all group member’s individual storyboards files and view controllers into Main.storyboard for functional app with functional navigation (different storyboard files from each member -> Main.storyboard)
- Built out the not-yet-functional settings view controller and basic idea of visualizations view controller, present basic visualizations that pull from CoreData (SettingsViewController.swift & VisualizationsViewController.swift)
--- BETA ---
- Co-authored daily notification reminder functionality with Jessica
- Improved upon visualizations view controller; adjusted appearance, colors, fonts, and allow for filtering
- Provided code review feedback for others’ pull requests to help maintain code readability


Jessica Ma (beta 25%, overall 24%)
--- ALPHA ---
- Login screen with connection to Firebase
- Added sign in screen with ability to sign up from the app itself, adding the entry to Firebase
- Created sign out button that pulls up the initial login screen again
--- BETA ---
- Co-authored daily notification reminder functionality with Tony
- Implemented the light and dark mode themes for all view controllers
- Saved the light/dark mode status to user defaults so it remains the same after closing/reopening the app

Francis Tran (beta 25%, overall 24%)
--- ALPHA ---
- Created two screens for users to input data.
- Added photo selection and camera usage
--- BETA ---
- Added "slider" that the user can tap on to select their mood rating
- Animated switching from the standard user input screen (only slider) to the expanded view (comments, photos)

Deviations:
--- ALPHA ---
- Have not yet implemented splash/loading screen yet because have not decided logo (we are not concerned about this because it should take a few minutes maximum)
- The settings and visualizations view controllers are part of our beta release, not alpha, so this part is not yet completely done but we had free worktime so we wanted to share this as well.
--- BETA ---
- Have not yet implemented the loading screen because we have not yet selected the logo (we are still not concerned about this because it should take a few minutes maximum)
