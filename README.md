Task Management App

 This is a simple task management app built with Flutter, BLoC, Local JSON as Storage. You can add, edit, delete, sort tasks and filter them by priority. The filter by prority works on all the tasks while sorting works on the tasks in the current column. The project is built in MVVM architecture where the folders are blocs, models, views, repositories, and main.dart, bloc folder contains logic for state management, models folder contains the task model, views folder contains the ui, repositories folder contains the data access layer, and main.dart is the entry point of the app. 
 
 Press the floating action "+" to add a new task. For drag and drop of the task card , long press the card and move between the status column. Press the filter button to filter the tasks by priority. Press the clear filter button to clear the filter in the Appbar. 
 Press the Sort button inside each column to sort the tasks by deadline and by priority.

 How to run it ?

1. Make sure you have Flutter installed on your computer
2. Make sure you have an emulator or a physical device connected
3. Clone the repository.
4. Run `flutter pub get` to install the packages
5. Connect your phone or open an emulator
6. Run `flutter run` to start the app 

Dependencies Involved:
  flutter_bloc: ^8.1.4
  equatable: ^2.0.5
  intl: ^0.19.0
  path_provider: ^2.1.2
  json_annotation: ^4.8.1
  uuid: ^4.3.3

Dev Dependencies Involved:
  build_runner: ^2.4.8
  json_serializable: ^6.7.1

To install these you can simply run `flutter pub get` after cloning the project or you can manually add them by searching these packages along with version on pub.dev and add them to the pubspec.yaml file.
