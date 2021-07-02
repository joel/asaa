# frozen_string_literal: true

require "application_system_test_case"

class ImagesTest < ApplicationSystemTestCase
  setup do
    @attachment = create(:attachment)
  end

  test "visiting the index" do
    visit images_url
    assert_selector "h1", text: "Images"
  end

  test "creating a Attachment" do
    visit images_url
    click_on "New Attachment"

    fill_in "Name", with: @attachment.name
    click_on "Save"

    assert_text "Attachment was successfully created"
    click_on "Back"
  end

  test "updating a Attachment" do
    visit images_url
    click_on "Edit", match: :first

    fill_in "Name", with: @attachment.name
    click_on "Save"

    assert_text "Attachment was successfully updated"
    click_on "Back"
  end

  test "destroying a Attachment" do
    visit images_url

    click_on "Destroy", match: :first

    assert_text "Attachment was successfully destroyed"
  end
end
