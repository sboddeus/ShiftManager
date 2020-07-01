# Shift Manager
A place to manage shifts

## Getting Started
Written with Xcode 11.5 targeting iOS SDK 13.5 and Catalyst 13.5

## Application Architecture
The application is written using the MVVM pattern. The quirk is that ViewModels are strictly value types and side effects from actions are managed by view model providers. This allows for high testability.

 NOTE: In practice, the MainSplitViewModel is a reference type. But that was a convience due to time constraints

## Third Party SDKs Used
- Alamofire: For networking. I would have used URLSession but a quirk with the API and said framework meant Alamofire was more suitable
- SDWebImage: Because it makes displaying images from the network easy
- SnapKit: Because it make laying views out in code a dream

## Known Defects
- Need more unit testing
- Has no integration or UI testing
- The UI is atrocious
- The app does not surface API errors to the user