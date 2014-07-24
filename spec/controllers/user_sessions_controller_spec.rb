require 'spec_helper'

describe UserSessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "renders the new tempalte" do
      get 'new'
      expect(response).to render_template('new')
    end
  end

  describe "POST 'create'" do
    context 'with correct credentials' do
      let!(:user) { User.create(first_name: "Kenji", last_name: "Miwa", email: "kmiwa@hotmail.com", password: '123456', password_confirmation: '123456') }

      it "redirects to the todo list path" do
        post :create, email: "kmiwa@hotmail.com", password: "123456"
        expect(response).to be_redirect
        expect(response).to redirect_to(todo_lists_path)
      end

      it "finds the user" do
        expect(User).to receive(:find_by).with( {email: "kmiwa@hotmail.com"} ).and_return(user)
        post :create, email: "kmiwa@hotmail.com", password: "123456"
      end

      it "authenticates the user" do
        User.stub(:find_by).and_return(user)
        expect(user).to receive(:authenticate)
        post :create, email: "kmiwa@hotmail.com", password: "123456"
      end

      it "set the user_id in the session" do
        post :create, email: "kmiwa@hotmail.com", password: "123456"
        expect(session[:user_id]).to eq(user.id)
      end

      it "sets the flash success message" do
        post :create, email: "kmiwa@hotmail.com", password: "123456"
        expect(flash[:success]).to eq("Thanks for logging in!")
      end
    end

    shared_examples_for "denied login" do


    end

    context 'with blank credentials' do
      it "renders the new template" do
        post :create
        expect(response).to render_template('new')
      end

      it "sets the flash error message" do
        post :create
        expect(flash[:error]).to eq("There was a problem with your credentials.")
      end
    end

    context 'with valid email but incorrect password' do
      let!(:user) { User.create(first_name: "Kenji", last_name: "Miwa", email: "kmiwa@hotmail.com", password: '123456', password_confirmation: '123456') }

      it "renders the new template" do
        post :create, email: user.email, password: 'incorrect'
        expect(response).to render_template('new')
      end

      it "sets the flash error message" do
        post :create
        expect(flash[:error]).to eq("There was a problem with your credentials.")
      end
    end
  end

end
