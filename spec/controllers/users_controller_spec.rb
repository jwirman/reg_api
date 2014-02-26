require 'spec_helper'

describe UsersController do

  let(:valid_attributes) { { "name" => "John Doe",
                             "email" => "john@doe.com",
                             "password" => "s3kr3t",
                             "password_confirmation" => "s3kr3t" } }

  describe "POST create" do

    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, valid_attributes.merge(format: :json)
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, valid_attributes.merge(format: :json)
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).to be_persisted
      end

      it "responds with the appropriate status code " do
        post :create, valid_attributes.merge(format: :json)
        expect(response.status).to eq 201
      end

      it "responds with the created user attributes" do
        post :create, valid_attributes.merge(format: :json)
        resp = JSON.parse(response.body)
        user = User.first
        expect(resp['id']).to eq user.id
        expect(resp['name']).to eq user.name
        expect(resp['email']).to eq user.email
        expect(resp['authentication_token']).to eq user.authentication_token
      end
    end

    describe "with invalid params" do
      before :each do
        User.any_instance.stub(:save).and_return(false)
      end

      it "assigns a newly created but unsaved user as @user" do
        post :create, { "name" => "invalid value" }
        expect(assigns(:user)).to be_a_new(User)
      end

      it "responds with the appropriate status code " do
        post :create, { "name" => "invalid value" }
        expect(response.status).to eq 422
      end

      it "calls the errors method to get error messages" do
        User.any_instance.should_receive(:errors).once
        post :create, { "name" => "invalid value" }
      end
    end

  end

end
