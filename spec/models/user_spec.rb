require 'spec_helper'

describe User do

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :password_confirmation }
  it { should validate_uniqueness_of :email }

  it "validates password equals password_confirmation" do
    user = User.new(name: 'blah', email: 'blah@blah.com', password: 'pass', password_confirmation: 'password')
    expect(user).to have(1).error_on(:password)
    expect(user.errors_on(:password)).to include('does not match password confirmation')
  end

  it "validates email format" do
    user = User.new(name: 'blah', email: 'not_well_formed@blah', password: 'pass', password_confirmation: 'pass')
    expect(user).to have(1).error_on(:email)
    expect(user.errors_on(:email)).to include('is not an email')
  end

  it 'formats output json' do
    user = User.create(name: 'blah', email: 'blah@blah.com', password: 'pass', password_confirmation: 'pass')
    json = user.as_json
    expect(json.key?(:id)).to be_true
    expect(json.key?(:name)).to be_true
    expect(json.key?(:email)).to be_true
    expect(json.key?(:authentication_token)).to be_true
  end

  it 'generates an auth token before saving' do
    user = User.new(name: 'blah', email: 'blah@blah.com', password: 'pass', password_confirmation: 'pass')
    expect(user.authentication_token).to be_nil
    user.save
    expect(user.authentication_token).to_not be_nil
  end

end
