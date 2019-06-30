# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MeetingXome' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MeetingXome
  pod 'Firebase'
  pod ‘Firebase/Core’
  pod 'Firebase/Auth'
  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'

  target 'MeetingXomeTests' do
    inherit! :search_paths
    # Pods for testing
  end
  target 'MeetingXomeUITests' do
        inherit! :search_paths
        pod 'Firebase'
    end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
      configuration.build_settings['SWIFT_EXEC'] = '$(SRCROOT)/SWIFT_EXEC-no-coverage'
    end
  end
end
