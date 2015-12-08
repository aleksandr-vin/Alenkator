# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Alenkator'
  app.archs += ['x86']
  app.permissions += ["android.permission.WRITE_EXTERNAL_STORAGE"]
  app.package = "co.evecon"
  app.version_code = "1"
  app.version_name = `git describe --tags --dirty`
end
