# EasyCount
EasyCount is a simple counting app written in Swift / SwiftUI using CoreData. The app is a work-in-progress project which I mainly use to learn the basics of SwiftUI and CoreData.
Feel free to open Pull requests or give me some feedback :smile:.

## Some details about the project
There are two entities in the CoreData model, `Counter` and `CounterDetail`. The `Counter` entity has a name, date of creation, a UUID, **and** holds a set of `CounterDetail` entities. Each `CounterDetail` entity contains an 64 bit integer variable for counting, a name and a UUID. 
This means a `Counter` can be thought of as holding a collection of entities used for actual counting.

#### `CounterView`
Contains the main view to create or delete new counters as well as open the settings menu.

#### `CounterDetailView`
Shows the 'CounterDetail' entities of a Counter. This screen can be reached using from the CounterView

#### `PreferenceView`
Contains the view for accessing user settings. Check out `UserSettings.swift` for preference variable declarations. 

#### `ActivityView`
Used in CounterDetailView for showing the activity sheet to export the CounterDetails of a Counter to `.csv` format.

#### The `Model` folder
This contains the mostly auto-generated files used by CoreData.

## Available Features
* Create / Remove / Rename counters containing CounterDetails
* Add / Subtract a user-definable integer amount from a CounterDetail
* Export a Counter to `.csv`
* Dark Mode

## To-Do
- [ ] Enhancing the CounterView text input (e.g. hide the keyboard on scroll-up)
- [ ] Non-glitchy way of renaming Counters
- [ ] Sorting of Counters (currently newest first)
- [ ] Renaming CounterDetails
- [ ] Counter resets (both individual CounterDetails as well as a whole Counter)
- [ ] Cloning of counters (maybe with template support)
- [ ] Write UI-Tests of the currently available features
- [ ] Maybe add optional Counter specific settings
- [ ] Maybe add option to go below 0 in counting.
 

