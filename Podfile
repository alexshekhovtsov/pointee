# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'pointee' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for pointee

  # Developer

  pod 'SwiftLint'
  pod 'R.swift', '5.1.0'

  # RxSwift

  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'RxGesture', '3.0.2'
  pod 'RxBiBinding', '0.2.5'
  pod 'RxFlow', '2.7.0'
  pod 'RxDataSources', '4.0.1'
  
  # Google

  pod 'GoogleMaps', '3.8.0'
  pod 'GooglePlaces', '3.8.0'

  # UI

  pod 'Reusable'
  pod 'LBTATools'
  pod 'NVActivityIndicatorView', '4.8.0'
  pod 'SideMenu'
  pod "AlignedCollectionViewFlowLayout"
  pod 'MultiSlider'

  # Other
  pod 'Kingfisher'
  pod 'KeychainSwift'
  pod 'IQKeyboardManagerSwift'
  pod 'ReachabilitySwift'

end

# Post install hooks
post_install do |installer|
  installer.pods_project.targets.each do |target|
    # Workaround for All Pods with old deployment target.
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end