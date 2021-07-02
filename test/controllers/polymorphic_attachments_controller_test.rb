# frozen_string_literal: true

require "test_helper"

class PolymorphicImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @attachment = create(:attachment)
    @user.attachments << @attachment
  end

  describe "#index" do
    context "with an attachment" do
      context "html" do
        it "should get index" do
          get user_images_url(user_id: @user.id)
          assert_response :success
          assert_match @attachment.name, @response.body
        end
      end

      context "json" do
        it "should get index json" do
          get user_images_url(user_id: @user.id, format: :json)
          assert_response :success
          assert_match %r{^http://www.example.com/users/(\d+)/attachments}, @response.location
          assert_match @attachment.name, JSON.parse(@response.body)[0]["name"]
        end
      end
    end
  end

  test "should get new" do
    get new_user_image_url(user_id: @user.id)
    assert_response :success
    assert_match %r{^http://www.example.com/users/(\d+)/attachments/new}, @request.url
  end

  test "should create attachment" do
    assert_difference -> { @user.attachments.count } => +1 do
      post user_images_url(user_id: @user.id), params: { attachment: { name: @attachment.name } }
    end

    assert_redirected_to user_image_url(user_id: @user.id, id: Attachment.last.id)
  end

  test "should show attachment" do
    get user_image_url(@user, @attachment)
    assert_response :success
    assert_match %r{^http://www.example.com/users/(\d+)/attachments/(\d+)}, @response.location
  end

  test "should get edit" do
    get edit_user_image_url(@user, @attachment)
    assert_response :success
    assert_match %r{^http://www.example.com/users/(\d+)/attachments/(\d+)/edit}, @response.location
  end

  test "should update attachment" do
    patch user_image_url(@user, @attachment), params: { attachment: { name: @attachment.name } }
    assert_redirected_to user_image_url(@user, @attachment)
  end

  test "should destroy attachment" do
    assert_difference -> { @user.attachments.count } => -1 do
      delete user_image_url(@user, @attachment)
    end

    assert_redirected_to user_images_url(@user)
  end
end
