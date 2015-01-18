Pod::Spec.new do |s|
  s.name             = "AzureSDK"
  s.version          = "0.0.1"
  s.summary          = "Windows Azure SDK for iOS."
  s.description      = <<-DESC
                       The Windows Azure SDK for iOS provides a library.

                       * Upload binary to Azure Blob with progress report.
                       * Native BFTask support.
                       DESC
  s.homepage         = "https://github.com/canius/azure-sdk-ios"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "canius" => "canius.chu@outlook.com" }
  s.source           = { :git => "https://github.com/canius/azure-sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'AzureSDK/**/*.[hm]'
  s.public_header_files = 'AzureSDK/**/*.h'
  s.dependency 'Bolts'
  s.dependency 'TMCache'
end
