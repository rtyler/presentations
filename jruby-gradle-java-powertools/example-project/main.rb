require 'colorize'
require 'java'

java_import 'com.github.rtyler.presentations.Demo'

puts $CLASSPATH

puts "> Running with Ruby: #{RUBY_VERSION} on #{RUBY_PLATFORM}"

message = "Hello JRubyConf EU"
puts "> sending echo message:  #{message}"
puts

puts Demo.new.echo(message).green
