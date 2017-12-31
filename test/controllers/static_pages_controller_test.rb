require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  def setup     # automatically run before every test
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"    # HTML selector
  end

  test "should get help" do
    get help_path
    assert_response :success    # :success is an abstract represantation of the HTTP status code (200 OK)
    assert_select "title", "Help | #{@base_title}"    # string interpolation
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end
