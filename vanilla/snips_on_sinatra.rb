require 'rubygems'
require 'sinatra'
require 'vanilla'

Sinatra::StaticEvent::MIME_TYPES.merge!({'' => 'text/plain'})
Sinatra::StaticEvent::MIME_TYPES.merge!({'js' => 'text/javascript'})

static('/public', 'vanilla/public')

Soup.prepare

# BAD Sinatra, SILLY Sinatra.  Polute my namespace at your peril.
# Removing the DSL methods from Renderers as these names will clash with how we allow
# dyna to be kinda little slices of REST on their own.  Might want to nobble other
# Sinatra DSL methods too.  Also from other classes.
Vanilla::Renderers::Base.class_eval {
  undef_method :get if instance_methods.include? 'get'
  undef_method :put if instance_methods.include? 'put'
  undef_method :post if instance_methods.include? 'post'
  undef_method :delete if instance_methods.include? 'delete'
}

get('/') { redirect Vanilla::Routes.url_to('start') }
['get', 'post', 'put', 'delete'].each do |method|
  send(method, '/:snip.:format') do
    Vanilla.present sort_out_the_params_you_muppet(params, method)
  end
  send(method, '/:snip/:part.:format') do
    Vanilla.present sort_out_the_params_you_muppet(params, method)
  end
end

def sort_out_the_params_you_muppet(params ={}, method = 'get')
  [:snip, :part, :format].each do |url_bit|
    params[url_bit] = CGI.unescape(params[url_bit]) unless params[url_bit].nil?
  end
  params[:method] = method
  params
end