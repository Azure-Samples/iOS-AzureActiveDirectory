# iOS - Azure Active Directory Demo
This is a sample which demonstrates how you an authenticate with Windows Azure Active Directory (WAAD) from an iOS application.  You will then use the access token retrieved from WAAD to gain access to a web service that has been secured with WAAD.

Below you will find requirements and deployment instructions.

## Requirements
* OSX - This sample was built on OS X (10.8.5) but should work with more current releases of OSX.
* XCode - This sample was built with XCode 5.0 and requires at least XCode 4.0 due to use of storyboards and ARC.
* Windows Azure Account - Needed to create the Windows Azure Active Directory Account as well as to deploy the web service to Web Sites (if you choose to do so).  [Sign up for a free trial](https://www.windowsazure.com/en-us/pricing/free-trial/).

## Third Party Code
There are two different pieces of third party code you'll need to download in order to compile this sample.  Follow the links below and place the code files in your application:

1.  NSData+Base64.h/.m can be downloaded from [this link](http://www.cocoawithlove.com/2009/06/base64-encoding-options-on-mac-and.html).
1.  URLParser.h/.m can be downloaded from [this link](http://dev.doukasd.com/2011/03/get-values-from-parameters-in-an-nsurl-string/).

## Source Code Folders
* /source/ - This contains code for the iOS Client application.

## Additional Resources
I've released a [blog post](http://chrisrisner.com/Accessing-Resources-Secured-By-Azure-Active-Directory-with-iOS-and-Android) which walks through this sample as well as how to setup the web service and WAAD account.  It's highly recommended to read this post before / while looking at the source code.

#Setting up your Windows Azure Active Directory account and Web Service
To set up your WAAD account and create a web service you can access with the clients, please read this post on [Securing a Windows Store Application and REST Web Service using Windows Azure AD](http://msdn.microsoft.com/en-us/library/windowsazure/dn169448.aspx).  

To make things easier, you can also download the source code from the above post [here](http://code.msdn.microsoft.com/AAL-Windows-Store-app-to-2430e331).  Be sure you change your **domainName** and **audience** variables in the **global.asax** file for the web service.

#Client Application Changes
The client application is currently set to run against an existing WAAD account and site I have set up.  At the time of writing, these services should be working and you should be able to authenticate using the following credentials:

1.  Username: testuser@christesttwo.onmicrosoft.com
1.  Password: ThisIs@Test

You can also follow instructions in [this post](http://chrisrisner.com/Accessing-Resources-Secured-By-Azure-Active-Directory-with-iOS-and-Android) regarding setting up your own service and AD account.

## Contact

For additional questions or feedback, please contact the [team](mailto:chrisner@microsoft.com).
