Pod::Spec.new do |s|
s.name                  = 'VSTwitterTextCounter'
s.version               = '0.1.0'
s.license               = { :type => 'MIT', :file => 'LICENSE' }
s.platform              = :ios, "8.0"
s.ios.deployment_target = '8.0'
s.authors               = { 'Shady Elyaski' => 'shady@elyaski.com' }
s.screenshots           = 'https://raw.github.com/DynamicSignal/ios-twitter-text-counter/master/Example/Assets/sample.gif'
s.homepage              = 'https://github.com/DynamicSignal/ios-twitter-text-counter'
s.summary               = 'Twitter\'s new progress based web UI.'
s.description           = 'This custom UIControl resembles Twitter\'s new progress based web UI that represents the number of characters left. It also handles highlighting any extra characters in your UITextView.'
s.source                = { :git => 'https://github.com/DynamicSignal/ios-twitter-text-counter.git', :tag => s.version.to_s}
s.social_media_url      = 'https://twitter.com/ShadyElyaski'
s.source_files          = 'VSTwitterTextCounter/Classes/**/*'
end
