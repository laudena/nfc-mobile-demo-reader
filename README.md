# demo_reader

Reads NFC cards and tags, displaying any stored URL data on screen. The application responds to a specific URL scheme, which allows it to open automatically when such a tag is scanned.

To test this, use an NTAG215 or a similar NDEF-compatible tag with enough storage capacity. Write a URL to the tag in the following format:

`kaspaterminal://any/text/can/go/here`

When your phone is actively in use (not just unlocked), place the tag near it. The application will automatically come to the foreground and display the URL data.

# Live demo
To see it live: https://youtube.com/shorts/jh1R2NbA48w?feature=share


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
