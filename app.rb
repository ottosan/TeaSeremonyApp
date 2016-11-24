require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'sinatra/json'
require './models/contribution.rb'
require './image_uploader.rb'

enable :sessions

get '/' do
	@contents = Contribution.order('id desc').all
	erb :index
end

# login and logout
get '/logout' do
	p "logout: " + session[:type]
	session[:type] = nil
	redirect '/'
end

post '/login' do
	@password = Password.first
	if params[:password] == @password.manager_password
		session[:type] = "manager"
	elsif params[:password] == @password.user_password
		session[:type] = "user"
	end
	#p "login: " + session[:type]
	redirect '/'
end

# show articles
get '/article/:id' do
	@content = Contribution.find(params[:id])
	@before = Contribution.where('id > ?', params[:id]).first
	@next = Contribution.where('id < ?', params[:id]).last
	p @before
	p @next
	if session[:type] == nil
		redirect '/'
	end
	erb :article
end

# manager contents
post '/new' do
	Contribution.create({
		title: params[:title],
		body: params[:body],
		img: ""
	})
	if params[:file]
		image_upload(params[:file])
	end
	redirect '/'
end

get '/new_article' do
	if session[:type] != "manager"
		redirect '/'
	end
	erb :new_article
end

post '/delete/:id' do
	Contribution.find(params[:id]).destroy
	redirect '/'
end

post '/edit/:id' do
	if session[:type] != "manager"
		redirect '/'
	end
	@content = Contribution.find(params[:id])
	erb :edit
end

post '/renew/:id' do
	@content = Contribution.find(params[:id])
	@content.update({
		title: params[:title],
		body: params[:body]
	})
	redirect '/'
end

get '/manage' do
	if session[:type] != "manager"
		redirect '/'
	end
	erb :manage
end

post '/change_pass' do
	if params[:type] == "user"
		Password.first.update_attribute(
			:user_password, params[:password]
		)
	else
		Password.first.update_attribute(
			:manager_password, params[:password]
		)
	end
	redirect '/manage'
end
