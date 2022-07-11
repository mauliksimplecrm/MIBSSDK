# MIBSSDK

# Installation

Installation with CocoaPods
-

To integrate MIBSSDK into your Xcode project using CocoaPods, specify it in your Podfile:

<sub> pod 'MIBSSDK' </sub>


# Usage

Objective C
-

Import SDK using below line in UIViewController.

<sub>

@import MIBSSDK;

</sub>

Below code is use for open SDK.

<sub>
MIBSInit *mc = [[MIBSInit alloc]initWithUv:self];

[mc loadData];
</sub>

Swift 
-
Import SDK using below line in UIViewController.

<sub>

import MIBSSDK

</sub>

Below code is use for open SDK.

<sub>

let mibssdk = MIBSInit(uv: self)

mibssdk.loadData()

</sub>
