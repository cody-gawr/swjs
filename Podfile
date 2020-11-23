# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

def shared_pods
	pod 'RxSwift', '~> 5'
	pod 'RxCocoa', '~> 5'
	pod 'NewRelicAgent', '~> 5.10.0'
	pod 'ReachabilitySwift', '~> 4.3.0'
end

def rx_bluetooth_kit
	pod 'RxBluetoothKit', '~> 5.0'
end

def notification_banner
	pod 'SwiftMessages'
end

def network
	pod 'Alamofire', '~> 4.8.2'
	pod 'SwiftyJSON'
end

target 'autobrain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  shared_pods
  rx_bluetooth_kit
  notification_banner
  network
  # Pods for autobrain
  
end
