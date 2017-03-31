require 'simplecov'
require 'coveralls'

formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter::new(formatters)

SimpleCov.start do
  add_filter { |src| !(src.filename =~ /lib/) }
  add_filter "spec.rb"
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'power_types'
require 'fileutils'

SPEC_SUPPORT_PATH = File.expand_path("../support", __FILE__)
SPEC_TMP_PATH = File.expand_path("../tmp", __FILE__)

Dir[File.join(SPEC_SUPPORT_PATH, "/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.after do
    FileUtils.rm_r Dir.glob File.join(SPEC_TMP_PATH, '*.*')
  end

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
