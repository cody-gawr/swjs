Autobrain iOS Application
===================
---------


Initial setup
-------------
This readme was written with utilization of xCode 8.3.2 and Swift 3.1. Your mileage may vary with these instructions.

> **Note:**

> - To be able to compile to a real device, you will need to be given access and create certificates from developer.apple.com

### Get the Repo
First, get the latest version of the master branch:
```
git clone git@github.com:swjg-ventures/mab-ios-swift.git
```

###  xCode setup

> - Open the ``Autobrain.xcworkspace`` file in xCode

> ** If you are planning to build to a device, you will need to manage your code signing **
> - After gaining access to the developer portal, create/download a signing certificate for your mac.
> - Go to the autobrain target of the project and make sure the team is set to Autobrain, LLC

###Installing Dependencies
```
brew update
brew install cocoapods
pod update
pod install
```

### Running on localhost
> **Note:**
> - You must also have the repo of Autobrain pulled (into a different folder)
> - Navigate to ``myautobrain`` and start the rails server ``rails s``
> - Open up a browser window and navigate to ``localhost:3000`` and be sure the app appears and is running.

To get the Autobrain Application running on localhost you should first find your local ip address by running ``ifconfig`` in the terminal.

Once found, open the folder ``autobrain`` in the tree directory in xCode.
Open ``APIClient.swift``
```
//APIClient.swift
//Find this line
let server = "https://stg.autobrain.com/"
//comment it out and replace with:
//https://www.whatismybrowser.com/detect/what-is-my-local-ip-address
let server = "http://[YOUR_IP_ADDRESS]:[PORT]/"

//example of this would be
//static let server = "http://192.123.4.567:3000/"
```

**For localhost on physical device**
>- Follow steps under the localhost setup and ensure the app is running locally in browser
>- Plug device into computer.
>- Choose physical device as target device.
>- Under ``Product`` in xCode you may need to fully build the app and sign it onto the device for its first run.
>- Additionally, the device may not be registered to the xCode managed profile. This can be seen under the ``General`` settings view. If it is not registered it, and it is a company device, then click ``register device``.
