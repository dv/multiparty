Gem::Specification.new do |s|
  s.name        = 'multiparty'
  s.version     = '0.2.0'
  s.summary     = 'Easily generate a multipart/form-data header and body.'
  s.authors     = ['David Verhasselt']
  s.email       = 'david@crowdway.com'
  s.homepage    = 'http://github.com/dv/multiparty'

  files         = %w(README.md Rakefile LICENSE)
  files        += Dir.glob("lib/**/*")
  files        += Dir.glob("spec/**/*")
  s.files       = files

  s.add_dependency  'mime-types'

  s.description = <<description
Easily generate a multipart/form-data header and body.
description
end
