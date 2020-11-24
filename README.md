# vc_cam

-What is the process to deploy/release the mobile app to the Google Play or Apple Store? 

-How would you manage back-end synchronization/versioning in response to Android or iOS updates?

    There a couple ways we could manage versioning, depending on the desired outcome. 
    
    -If we always want the user to have the latest version and nothing less, then we can check check if there is a more up to date version in the app/play store upon launching the app. If there is a newer version available, then the user can be prompted to update the app in order to proceed using the app. 

    -If the concern is whether or not the app will continue to work with updates to a backend api, then a minimum compatible version could be stored on the server. You could then send a get request upon launching the app to see if that particular version can continue to be used.

    There are other possible ways to maintain synchronization depending on the desired effect.

