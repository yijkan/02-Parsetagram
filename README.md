# Project - Parsetagram

**Parsetagram** is a photo sharing app using Parse as its backend.

Time spent: **24.5** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite Scrolling
- [x] User can tap a post to view post details, including timestamp and creation
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user.

The following **optional** features are implemented:

- [ ] Show the username and creation time for each post
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse.
- [ ] User Profiles:
   - [ ] Allow the logged in user to add a profile photo
   - [ ] Display the profile photo with each post
   - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [ ] User can like a post and see number of likes for each post in the post details screen.
- [x] Run your app on your phone and use the camera to take the photo


The following **additional** features are implemented:

- [x] Auto Layout, with ImageViews and TableViewCells resizing as well

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Apparently editing images has a bug when you try to "edit" an image from the camera where you can't move the cropping field.
2. Also iOS causes orientation issues if you take the picture with the camera oriented differently but don't edit them.

## Video Walkthrough

Here's a walkthrough of implemented user stories:
User can sign up and start viewing posts. User can also scroll infinitely and pull to refresh. Tapping a post leads to a details page

<img src='http://i.imgur.com/lbGvvEF.gif' title='signup-viewing' width='' alt='Sign up and view posts' />

User can upload or take a new photo

<img src='http://i.imgur.com/trvgGGX.gif' title='new' width='' alt='Make a new post' />

User can view their own posts

<img src='http://i.imgur.com/QocXbqK.gif' title='profile' width='' alt='View only your own posts' />

User can log out, log in, and have logged-in status preserved

<img src='http://i.imgur.com/jG1Dvuo.gif' title='logout' width='' alt='Log out, log in, stay logged in' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [Parse]
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [MBProgressHUD]
- [warchimede's Custom Swift Animations](https://github.com/warchimede/CustomSegues)
- UIColorFromHex function from [here](https://coderwall.com/p/6rfitq/ios-ui-colors-with-hex-values-in-swfit)
- Icons: [App icon](http://iconmonstr.com/photo-camera-9/), [Home tab](https://www.iconfinder.com/icons/216242/home_icon#size=128), [New tab](http://iconmonstr.com/photo-camera-8/), [Profile tab](https://thenounproject.com/search/?q=person&i=961), [Camera button](https://www.iconfinder.com/icons/115759/camera_icon#size=128), [Camera roll button](https://www.iconfinder.com/icons/290130/camera_image_photo_photography_photos_icon#size=128)

## Notes

Auto Layout was generally very difficult to work with.
Also, I think I need to work on doing things one at a time, because since the functionality and UI of the app are interconnected, I end up trying to figure everything out at once instead of starting with something and building it up iteratively. I want the design and layout to make sense in context of the features of the app, but I don't want to assume that I will be able to implement all of the features that I have in mind (ex: create a button for something that I "will" get to but end up not being able to figure out or finish that feature). At the same time, I don't want to have to go back and add something to a layout that I already spent a lot of time putting together.
Next time I will probably work on getting the coding done first while keeping track of the UI elements I'll need and then worry about getting everything connected.

## License

    Copyright [2016] [Yijin Kang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
