# Imagesynthesis-app

An IOS app that use segmented human image from foreground picture and merge it with background picture. 

# Requirements:

- Swift > 4
- IOS > 12

# Installation:

- Download the github project

- Once downloaded,open the project in xcode(open photosynthesis.xcodeproj)

- Download the coreml model from the given google drive link:

    https://drive.google.com/open?id=1LCJz7gQ2fbb3eNAU_JyNWcY9SL24tsMa

- Drag the downloaded model into project workspace 

- Build the app and run it in iphone

# Debug:

Incase ran into an error like cycles inside photosynthesis app or multiple files using this app, go to project -> build phases -> copy bundle resources -> delete the photosynthesis.app included in it (select the photosynthesis.app and click "-"). 



