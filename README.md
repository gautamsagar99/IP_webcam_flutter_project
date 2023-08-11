# IP Webcam flutter project

This project will help you create a mobile server and expose your phone camera to the requested device using url.
This is developed for intranet or local network application.

In this repoistory I am providing a python file(ConnectMobileCamera.ipynb) which uses phone camera via url which is normally done using opencv library.

## Getting Started

### Option 1:

1. Clone this repo.(please connect the phone using cable)
2. Update the IP address of your mobile in main.dart file(refer below link for getting your mobile IP)
3. Run the application using

```
 flutter run
```

### Option 2(recommended):

1. Try to create entire new project and copy paste the main.dart file
2. Update the dependencies in pubspec.yaml file and run

```
flutter pub get
```

3. Update the IP address of your mobile in main.dart file(refer below link for getting your mobile IP)
4. Now run the application using

```
flutter run
```

Now after the application is installed and running in the phone.

### press the bottom right corner button to start the server.

Now you can use the python file and run in separte folder using jupyter notebook.

After running you can view the mobile camera in your desktop.

if you want to connect your mobile using wifi you can refer this link where it is explained properly.

https://appmaking.com/run-flutter-apps-on-android-device/

Special Thanks (credits) to www.appmaking.com for providing proper explaination for connecting mobile using wifi.
