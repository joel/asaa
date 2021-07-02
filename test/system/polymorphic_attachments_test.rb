# frozen_string_literal: true

require "application_system_test_case"

class PolymorphicImagesTest < ApplicationSystemTestCase
  setup do
    @user = create(:user)
    @attachment = create(:attachment)
    @user.attachments << @attachment
  end

  test "add attachment" do
    visit users_url
    assert_selector "h1", text: "Users"

    click_on "Add Attachment", match: :first
    fill_in "Name", with: @attachment.name
    attach_file "image_attachment", Rails.root.join("test/fixtures/favicon.ico")
  end

  test "visiting the index" do
    visit user_images_url(user_id: @user)
    assert_selector "h1", text: "Attachments"
  end

  test "creating a Attachment" do
    visit user_images_url(@user)
    click_on "New Attachment"

    fill_in "Name", with: @attachment.name
    click_on "Save"

    assert_text "Attachment was successfully created"
    click_on "Back"
  end

  test "updating a Attachment" do
    visit user_images_url(@user)
    click_on "Edit", match: :first

    fill_in "Name", with: @attachment.name
    click_on "Save"

    assert_text "Attachment was successfully updated"
    click_on "Back"
  end

  test "destroying a Attachment" do
    visit user_images_url(@user)

    click_on "Destroy", match: :first

    assert_text "Attachment was successfully destroyed"
  end
end
