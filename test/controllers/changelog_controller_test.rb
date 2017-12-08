require "test_helper"

describe ChangelogController do
  it "should get index" do
    get 'changelog'
    value(response).must_be :success?
  end

end
