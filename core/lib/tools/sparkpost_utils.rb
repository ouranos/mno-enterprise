if defined?(::Bundler)
  dir = ENV['rvm_path'] + '/gems/' + ENV['RUBY_VERSION'] + '@global/gems/*/lib'
  $LOAD_PATH.concat Dir.glob(dir)
end

require 'awesome_print'
require 'sparkpost'

ENV['SPARKPOST_API_KEY'] = 'b62dfce2fee5a2607162a3b0bcc19d02c7fc9787'

class SparkpostlUtils

end



# List Mandril Templates
mandrill = Mandrill::API.new(MnoEnterprise.mandrill_key)
templates = mandrill.templates.list

ap templates.map {|h| h['name']}

# List Sparkpost templates
sp = SparkPost::Client.new()
templates = sp.templates.list

ap templates
