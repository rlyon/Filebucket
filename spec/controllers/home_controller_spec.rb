require 'spec_helper'

describe HomeController, "viewing index" do
  render_views
  it "should show welcome for unauthenticated users" do
    get 'index'
    response.body.should =~ /Welcome to the IBEST FileBox/m
  end
  
  it "should list files for authenticated users" do
    sign_in @user
    get 'index'
    response.body.should =~ /Home Directory/m
  end
end

describe HomeController, "browsing files" do
  it "should not allow unauthenticated users in browse"
end

describe HomeController, "sharing folders" do
  it "should not allow unauthenticated users in share"
end

describe HomeController, "unsharing folders" do
  it "should not allow unauthenticated users in unshare"
end
