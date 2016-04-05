# the name of the project
workspace 'GreedDB'

platform :ios, '6.0'

# the path of test project
xcodeproj 'Example/Example'

def target_pods
    # the path of .podspec
    pod 'GreedDB', :path => './'
end

target 'Example' do
    target_pods
end

target 'ExampleUnitTests' do
    target_pods
end

