# Flicks

Flicks is a movie app for IOS

Submitted by: Yat Choi

Time spent: ~20 hours spent in total

## User Stories

The following **required** functionality is complete:

* [ ] User can view a list of movies currently playing in theaters from The Movie Database. Poster images must be loaded asynchronously.
* [ ] User can view movie details by tapping on a cell.
* [ ] User sees loading state while waiting for movies API.
* [ ] User sees an error message when there's a networking error.
* [ ] User can pull to refresh the movie list.
* [ ] Add a tab bar for Now Playing or Top Rated movies.
* [ ] Implement a UISegmentedControl to switch between a list view and a grid view.

The following **optional** features are implemented:
* [ ] Add a search bar
* [ ] All images fade in as they are loading.
* [ ] For the large poster, load the low-res image first and switch to high-res when complete. (low)
* [ ] Customize the highlight and selection effect of the cell.
* [ ] Customize the navigation bar
* [ ] Tapping on a movie poster image shows the movie poster as full screen and zoomable
* [ ] User can tap on a button to play the movie trailer.

The following **additional** features are implemented:

- [ ] When zoomed into full screen image, double tap to resize to original zoom
- [ ] Swipe left to go back from full screen image.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://imgur.com/PSvqhq3' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

The biggest challenge I had was figuring out how to first have a Nav controller handle the top bar,
then have two instances of my main view controller handle "Now Playing" vs "Top Rated", and then
finally having each main view controller maintain two sub view controllers for table vs grid view!

I didn't want to just use the storyboard and stack objects on top of each other because it made
for a pretty ugly development experience. It also felt pretty hacky, so I tried to just do it the
right way using Container View principles. In the end, I learned a lot about how controllers talk
to each other via Delegates, and I even extended my top level UITabController to implement a
new delegate I created in order to keep the List/grid option the same between tabs.

A final, small challenge I had was figuring out how to play Youtube videos. Apparently, embedding
videos into the app is against Youtube ToS, so my first iteration involved simply opening up the
link in Safari or the Youtube app. I ended up installing a YouTube player Cocoapod that did the job!
Unfortunately, it doesn't work for some reason in the Simulator, but works perfectly fine on my
own device!

## License

    Copyright 2016 Yat Choi

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
