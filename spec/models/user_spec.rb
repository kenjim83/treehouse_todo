require 'spec_helper'

describe User do
  let(:valid_attributes) {
    {
      first_name: "Kenji",
      last_name: "Miwa",
      email: "kmiwa@hotmail.com",
      password: "123456",
      password_confirmation: "123456"
    }
  }
  context "saving a new user" do
    let(:user){ User.new(valid_attributes) }

    before do
      User.create(valid_attributes)
    end

    it "requires an email" do
      expect(user).to validate_presence_of(:email)
    end

    it "requires a unique email" do
      expect(user).to validate_uniqueness_of(:email)
    end

    it "requires a unique email (case insensitive)" do
      user.email = "KMIWA@HOTMAIL.COM"
      expect(user).to validate_uniqueness_of(:email)
    end

    it "requires the email address to look like an email" do
      user.email = "kenji"
      expect(user).to_not be_valid
    end

  end

  context "#downcase_email" do
    it "makes the email attribute lowercase" do
      user = User.new(valid_attributes.merge(email: "KMIWA@HOTMAIL.COM"))
      # user.downcase_email
      # expect(user.email).to eq("kmiwa@hotmail.com")
      expect{ user.downcase_email }.to change{ user.email }
        .from("KMIWA@HOTMAIL.COM")
        .to("kmiwa@hotmail.com")
    end

    it "downcases an email before saving" do
      user = User.new(valid_attributes)
      user.email = "KMIWA@HOTMAIL.COM"
      expect(user.save).to be_true
      expect(user.email).to eq("kmiwa@hotmail.com")
    end

  end
end
