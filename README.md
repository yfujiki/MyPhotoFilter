MyPhotoFilter
=============

## Training App For iOS8 Action Extension

### Link to the accompanying slide
http://www.slideshare.net/yfujiki/action-extension

### Requirements
* **Xcode 6 Beta 3**
* Experience of iOS development on Xcode
* Thorough knowledge of Swift language

### Description
As an end product, this project provides a photo filtering extension that works for the containing app, Photos app and image page on Safari. 
As a training project, this project guides you through steps. 

1. Clone the code 
2. git checkout refs/tags/step0

And you will have a single view app with image on it. By checking out step1 ~ step 8, you will see different stage of development.

- **Note : Please run on iPhone 4S simulator although the project is configured as universal app. Implementation with  size class is apparently not working properly 😅**

#### Step 1
* ActionExtension with ActivationRule set to image count = 1

#### Step 2
* Pass image from host app to guest app

#### Step 3
* Receive image from Photos app

#### Step 4
* Edit image on extension using CoreImage filter (This step is totally not relevant with extension itself, so you can skip if you want)

#### Step 5
* Pass the image back to Host app

#### Step 6
* Save into photo app

#### Step 7
* Decouple into framework

#### Step 8
* Add Safari extension




