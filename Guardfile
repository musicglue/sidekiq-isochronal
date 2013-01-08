# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :spork do
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  # watch(%r{^lib/(.+)\.rb$})                        { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^lib/sidekiq/isochronal/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

  watch('spec/spec_helper.rb')            { "spec" }

  watch(%r{^spec/support/(.+)\.rb$})      { "spec" }
end


