# presenterremote

A ProPresenter Remote application built in Flutter for multiple platforms (iOS, Android, web). Offering a user the ability to remotely control the slides on a ProPresenter instance running on the local network.

## Getting Started

This project is an attempt to create a straightforward app that a speaker from the stage can use to control the ProPresenter slides running on a back of the room computer. It's goal is to provide a simple, user-friendly UI to view and trigger the slides of the currently selected presentation without surfacing any other functionality that isn't necessary for a speaker/presenter to see on the app screen.

The app uses ProPresenter's public API to interface with it: (https://openapi.propresenter.com/)
- Many of the functions interfacing with the ProPresenter API are inspired the ProPresenter API wrapper for Dart created by @jeffmikels: (https://github.com/jeffmikels/ProPresenter-API)

