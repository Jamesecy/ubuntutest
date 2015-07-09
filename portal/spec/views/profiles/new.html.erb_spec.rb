require 'rails_helper'

RSpec.describe "profiles/new", type: :view do
  before(:each) do
    assign(:profile, Profile.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :username => "MyString"
    ))
  end

  it "renders new profile form" do
    render

    assert_select "form[action=?][method=?]", profiles_path, "post" do

      assert_select "input#profile_first_name[name=?]", "profile[first_name]"

      assert_select "input#profile_last_name[name=?]", "profile[last_name]"

      assert_select "input#profile_username[name=?]", "profile[username]"
    end
  end
end
