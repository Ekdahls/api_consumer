class UsersController < ApplicationController

  # HEJ SIMON

  require 'rest_client'

  API_BASE_URL = "http://localhost:3000/api" # base url of the API

  def index
    uri = "#{API_BASE_URL}/users.json" # specifying json format in the URl
    rest_resource = RestClient::Resource.new(uri) # It will create new rest-client resource so that we can call different methods of it
    users = rest_resource.get # will get back you all the detail in json format, but it will we wraped as string, so we will parse it in the next step.
    @users = JSON.parse(users, :symbolize_names => true) # we will convert the return data into array of hash.see json data parsing here
  end

  def new

  end

  #NOTE :  see below how we are passing the payload and content type while making the post call
  def create
    uri = "#{API_BASE_URL}/users"
    payload = params.to_json # converting the params to json
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.post payload , :content_type => "application/json"
      flash[:notice] = "User Saved successfully"
      redirect_to users_path # take back to index page, which now list the newly created user also
    rescue Exception => e
     flash[:error] = "User Failed to save"
     render :new
    end
  end

  def edit
    uri = "#{API_BASE_URL}/users/#{params[:id]}.json" # specifying format as json so that
                                                      # json data is returned
    rest_resource = RestClient::Resource.new(uri)
    users = rest_resource.get
    @user = JSON.parse(users, :symbolize_names => true)
  end

  def update
    uri = "#{API_BASE_URL}/users/#{params[:id]}"
    payload = params.to_json
    rest_resource = RestClient::Resource.new(uri)
    begin
      rest_resource.put payload , :content_type => "application/json"
      flash[:notice] = "User Updated successfully"
    rescue Exception => e
      flash[:error] = "User Failed to Update"
    end
    redirect_to users_path
  end

  def destroy
    uri = "#{API_BASE_URL}/users/#{params[:id]}"
    rest_resource = RestClient::Resource.new(uri)
    begin
     rest_resource.delete
     flash[:notice] = "User Deleted successfully"
    rescue Exception => e
     flash[:error] = "User Failed to Delete"
    end
    redirect_to users_path
   end
end
