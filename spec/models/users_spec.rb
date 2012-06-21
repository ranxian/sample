require 'spec_helper'

describe "Users" do
  before do
    @user = User.new(name: 'Xianran', email: 'xranthoar@gmail.com', 
                     password: '12345678', password_confirmation: '12345678')
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }

  describe "when the name field is blank" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when the email field is blanck" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a' * 55 }
    it { should_not be_valid }
  end

  describe "when email is invalid" do
    it "should be invliad" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |add|
        @user.email = add
        @user.should_not be_valid
      end
    end
  end

  describe "when email is valid" do
    it "should be valid" do
      addresses = %w[ser@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@ba.com]
      addresses.each do |add|
        @user.email = add
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed letters" do
    let(:mixed_letter_email) { "Dssfas@email.com" }

    it "should have been stored in the downcase form" do
      @user.email = mixed_letter_email
      @user.save
      @user.reload.email.should == mixed_letter_email.downcase
    end
  end

  describe "when password is blank" do
    before { @user.password = @user.password_confirmation = ' ' }

    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }  
  end

  describe "return value of the authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do 
      let(:found_user_with_invalid_password) { found_user.authenticate('invalidpasswd') }

      it { should_not == found_user_with_invalid_password }
      specify { found_user_with_invalid_password.should be_false }
    end
  end

  describe "when password is too short" do
    before { @user.password = 'a' * 5 }

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
end