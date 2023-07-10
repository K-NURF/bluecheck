# Bluecheck

## Mobile application to Mark Attendance in Higher Academic Institutions Using Bluetooth Low Energy.

This project is Flutter based application, designed to help academic institutions mark attendance in a fast and efficient way

### Prerequisites for a fully running project

In order to effectively run this application one should have:

 - **Flutter installed in PC.**

One can download and install it from the link below:

[Flutter](https://flutter.dev/)

- **Android Studio**

One can download and install it from the link below:

[Android Studio](https://developer.android.com/studio/install)

After installation run the following command in terminal. Ensure you are in the flutter directory.


```flutter doctor```

### What to expect in the application

This application has:

1. Login and register page
2. Additional user information page
3. Lecturer side. 

Which contains the following: 
  - Create class
  - Create session
  - Mark attendance
  - View attendance history
4. Student side

Which contains the following: 
  - Join class
  - Mark attendance
  - View attendance history

### How the application works

The application is designed to work differently for the lecturers and students. 

**Lecturers**

From this endpoint, the lecturer is supposed to create a class, and from this existing class, the lecturer creates sessions that represent the different lessons that are attended in the semester. 

After that, they simply press the button to mark attendance, and a random pin is generated that is broadcasted to all the connected devices via Bluetooth. When all students have marked their attendance, there is a list generated that shows all the students and whether they are present or absent.

**Students**

Once logged in and joined to a class all they have to do is to wait for the lecturer to broadcast the Bluetooth generated pin. This signal pops on their view as a button that prompts them to mark their attendance. Once the attendance marking process is done, they can view their attendance history. 


### Relevant Sources

In order for the project to be complete, extensive research was done from articles of related works and youtube tutorials. 
