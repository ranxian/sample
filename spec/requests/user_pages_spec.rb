require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "Signup Page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: 'Sign up') }
  end

  describe "Profile Page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('title', text: user.name) }
    it { should have_selector('h1',    text: user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create My Account" }

    describe "with invalid signup information" do
      it "should not create new user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid signup information" do
      before do
        fill_in "Name", with:  "Example User"
        fill_in "Email", with: "Example@somesite.com"
        fill_in "Password", with: "12345678"
        fill_in "Confirmation", with: '12345678'
      end
      it "should create one new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end