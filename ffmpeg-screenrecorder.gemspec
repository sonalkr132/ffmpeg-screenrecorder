lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffmpeg/version'

Gem::Specification.new do |spec|
  spec.name    = 'ffmpeg-screenrecorder'
  spec.version = FFMPEG::ScreenRecorder::VERSION
  spec.authors = ['Lakshya Kapoor']
  spec.email   = ['kapoorlakshya@gmail.com']

  spec.summary     = 'Record your computer screen using ffmpeg via Ruby.'
  spec.description = 'Ruby gem to record your computer screen - desktop or specific application/window' \
                     ' - using FFmpeg (https://www.ffmpeg.org).'
  spec.homepage    = 'http://github.com/kapoorlakshya/ffmpeg-screenrecorder'
  spec.license     = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'watir', '~> 6.0'
  spec.add_development_dependency 'webdrivers', '~> 3.0'

  spec.add_runtime_dependency 'os', '~> 0.9.0'
  spec.add_runtime_dependency 'streamio-ffmpeg', '~> 1.0'
end
