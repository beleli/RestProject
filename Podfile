# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TasksApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TasksApp
  pod 'EasyRest'
  pod 'IQKeyboardManagerSwift'
  pod 'KeychainSwift'
  pod 'BFKit-Swift'
  pod 'DatePickerDialog'
  pod 'RealmSwift'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        compatibility_pods = ['Genome']
        if compatibility_pods.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
