# frozen_string_literal: true

require "application_system_test_case"

class NotesPolymorphicAttachmentsTest < ApplicationSystemTestCase
  setup do
    @note = create(:note)
    @attachment = create(:attachment)
    @note.attachments << @attachment
  end

  test "add asset" do
    visit notes_url
    assert_selector "h1", text: "Notes"
    click_on "Add Attachment", match: :first
    fill_in "Name", with: @attachment.name
    attach_file "attachment_asset", Rails.root.join("test/fixtures/yoda.jpeg")
    fill_in "Name", with: @attachment.name
    click_on "Save Attachment"
    find("#preview").visible?
    Note.last.destroy
  end

  test "show page back url" do
    note = create(:note)
    attachment = create(:attachment)
    note.attachments << attachment

    visit polymorphic_url([note, attachment])
    assert_text note.name
    assert_text "No Attachment"
    click_on "Back"

    assert_equal "/notes/#{note.id}/attachments", URI.parse(current_url).path
  end

  test "show page edit url" do
    note = create(:note)
    attachment = create(:attachment)
    note.attachments << attachment

    visit polymorphic_url([note, attachment])
    assert_text note.name
    assert_text "No Attachment"
    click_on "Edit"

    assert_equal "/notes/#{note.id}/attachments/#{attachment.id}/edit", URI.parse(current_url).path
  end

  test "show page show behaveable url" do
    note = create(:note)
    attachment = create(:attachment)
    note.attachments << attachment

    visit polymorphic_url([note, attachment])
    assert_text note.name
    assert_text "No Attachment"
    click_on "Show Note"

    assert_equal "/notes/#{note.id}", URI.parse(current_url).path
  end

  # click_on "Add Attachment", match: :first

  # test "visiting the index" do
  #   visit note_attachments_url(note_id: @note)
  #   assert_selector "h1", text: "Attachments"
  # end

  # test "creating a Attachment" do
  #   visit note_attachments_url(@note)
  #   click_on "New Attachment"

  #   fill_in "Name", with: @attachment.name
  #   click_on "Save"

  #   assert_text "Attachment was successfully created"
  #   click_on "Back"
  # end

  # test "updating a Attachment" do
  #   visit note_attachments_url(@note)
  #   click_on "Edit", match: :first

  #   fill_in "Name", with: @attachment.name
  #   click_on "Save"

  #   assert_text "Attachment was successfully updated"
  #   click_on "Back"
  # end

  # test "destroying a Attachment" do
  #   visit note_attachments_url(@note)

  #   click_on "Destroy", match: :first

  #   assert_text "Attachment was successfully destroyed"
  # end
end
