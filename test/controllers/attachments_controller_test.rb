# frozen_string_literal: true

require "test_helper"

class AttachmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attachment = create(:attachment)
  end

  describe "#index" do # rubocop:disable Metrics/BlockLength
    context "with an attachment" do # rubocop:disable Metrics/BlockLength
      context "html" do
        it "should get index" do
          get attachments_url
          assert_response :success
          assert_match @attachment.name, @response.body
        end
      end

      context "json" do
        it "should get index json" do
          get attachments_url(format: :json)
          assert_response :success
          assert_match %r{^http://www.example.com/attachments}, @response.location
          assert_match @attachment.name, JSON.parse(@response.body)[0]["name"]
        end
      end

      context "with a behaveable" do
        setup do
          @user = create(:user)
          @user.attachments << @attachment
        end

        context "json" do
          it "should get index json" do
            get attachments_url(user_id: @user.id, format: :json)
            assert_response :success
            assert_match %r{^http://www.example.com/users/(\d+)/attachments}, @response.location
            assert_match @attachment.name, JSON.parse(@response.body)[0]["name"]
          end
        end
      end
    end
  end

  test "should get index" do
    get attachments_url
    assert_response :success
    assert_match @attachment.name, @response.body
  end

  test "should get index json" do
    get attachments_url(format: :json)
    assert_response :success
    assert_match @attachment.name, JSON.parse(@response.body)[0]["name"]
  end

  test "should get new" do
    get new_attachment_url
    assert_response :success
  end

  test "should create attachment" do
    assert_difference("Attachment.count") do
      post attachments_url,
           params: { attachment: { name: @attachment.name,
                                   asset: fixture_file_upload("test/fixtures/favicon.ico",
                                                              "attachment/vnd.microsoft.icon") } }
    end

    assert_redirected_to attachment_url(Attachment.last)
    assert_equal "favicon.ico", Attachment.last.asset.filename.to_s
  end

  test "should show attachment" do
    get attachment_url(@attachment)
    assert_response :success
  end

  test "should get edit" do
    get edit_attachment_url(@attachment)
    assert_response :success
  end

  test "should update attachment" do
    patch attachment_url(@attachment), params: { attachment: { name: @attachment.name } }
    assert_redirected_to attachment_url(@attachment)
  end

  test "should destroy attachment" do
    assert_difference("Attachment.count", -1) do
      delete attachment_url(@attachment)
    end

    assert_redirected_to attachments_url
  end
end
