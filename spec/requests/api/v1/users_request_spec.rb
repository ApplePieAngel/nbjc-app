require 'rails_helper'
require 'support/auth_helper'
include AuthHelper

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { FactoryBot.create(:random_user) }
  describe "GET users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :index, params: { auth0_id: "provider|1234" }
        expect(response.status).to eq(401)
      end
    end

    describe "With a valid auth token" do
      before do 
        controller.stub(:authenticate_request! => true)
      end
      
      it 'gets returns an error if user is not found' do
        controller.stub(:get_current_user! => nil)
        newUser = "provider|5678"
        get :index, params: { auth0_id: newUser }
        expect(response.status).to eq(404)
        expect(JSON.parse(response.body)["error"]).to eq("User not found")
      end

      it 'gets a user id given an auth0 id' do
        @auth0_id_test = "provider|1234"
        payload = { sub: @auth0_id_test }
        token = JWT.encode payload, nil, 'none'
        request.headers["Authorization"] = "Bearer #{token}"
        get :index, params: { auth0_id: @auth0_id_test }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['id']).to eq(user.id)
      end

      it 'gets a user\'s profile' do
        @auth0_id_test = "provider|1234"
        payload = { sub: @auth0_id_test }
        token = JWT.encode payload, nil, 'none'
        request.headers["Authorization"] = "Bearer #{token}"
        get :show, params: { id: 4, user: { id: 4 } }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['user']['auth0_id']).to eq(@auth0_id_test)
        expect(JSON.parse(response.body)['data']['user']['username']).to eq(user.username)
      end
    end
  end

  describe "POST users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :create, params: { auth0_id: "provider|1234" }
        expect(response.status).to eq(401)
      end
    end

    describe "With a valid auth token" do
      test_user = {
        auth0_id: "provider|5678",
        username: "username"
      }
      before do 
        controller.stub(:authenticate_request! => true)
      end

      it 'creates a new user' do
        post :create, params: { user: test_user }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body).size).to eq(1)
      end
    end
  end

  describe "UPDATE users route" do
    describe "Without a valid auth token" do
      it 'gets an auth error' do
        request.headers["Authorization"] = "Bearer INVALID_TOKEN"
        get :update, params: { id: 1, user: { id: 1, username: "newUserName" } }
        expect(response.status).to eq(401)
      end
    end

    describe "With a valid auth token" do
      before do 
        controller.stub(:authenticate_request! => true)
      end
      it 'updates a user\'s profile' do
        @auth0_id_test = "provider|1234"
        payload = { sub: @auth0_id_test }
        token = JWT.encode payload, nil, 'none'
        request.headers["Authorization"] = "Bearer #{token}"        
        get :update, params: { id: 9, user: { id: 9, username: "newUserName" } }
        expect(response).to have_http_status(:created)
      end
    end
  end
end
