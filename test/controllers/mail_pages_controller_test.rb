require 'test_helper'

class MailPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get inbox" do
    get mail_pages_inbox_url
    assert_response :success
  end

  test "should get sent" do
    get mail_pages_sent_url
    assert_response :success
  end

  test "should get draft" do
    get mail_pages_draft_url
    assert_response :success
  end

  test "should get trash" do
    get mail_pages_trash_url
    assert_response :success
  end

  test "should get compose" do
    get mail_pages_compose_url
    assert_response :success
  end

end
