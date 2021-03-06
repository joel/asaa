# frozen_string_literal: true

require "test_helper"

class AttachmentsHelperTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
  include AttachmentsHelper

  describe "#nested_helper_url" do
    context "without resource" do
      test "should render route helper url" do
        resource_name = "attachments"
        location_url  = "/attachments"
        mock(self).location_url(resource_name: resource_name, action: nil, behaveable: nil, resource: nil) do
          location_url
        end
        mock(self).regular(location_url: location_url, resource: nil)

        nested_helper_url(resource_name: resource_name, behaveable: nil)
      end
    end

    context "with resource" do
      test "with resource" do
        resource_name = "attachments"
        location_url  = "/users/42/attachments"
        resource = nil
        behaveable = stub
        mock(self).location_url(resource_name: resource_name, action: nil, behaveable: behaveable,
                                resource: resource) do
          location_url
        end
        mock(self).nested(location_url: location_url, behaveable: behaveable, resource: resource)

        nested_helper_url(resource_name: resource_name, behaveable: behaveable)
      end
    end
  end

  describe "#nested" do
    setup do
      @location_url = "somewhere_url"
    end

    context "without resource" do
      test "should render route helper url" do
        behaveable = stub
        mock(self).somewhere_url(behaveable) { "/users/42/attachments" }
        assert_equal "/users/42/attachments", send(:nested, location_url: @location_url, behaveable: behaveable)
      end
    end

    context "with resource" do
      test "with resource" do
        resource   = stub
        behaveable = stub
        # mock(resource).id { nil }
        mock(self).somewhere_url(behaveable, resource) { "/users/42/attachments/24" }

        assert_equal "/users/42/attachments/24",
                     send(:nested, location_url: @location_url, behaveable: behaveable, resource: resource)
      end
    end
  end

  describe "#regular" do
    setup do
      @location_url = "somewhere_url"
    end

    context "without resource" do
      test "should render route helper url" do
        mock(self).somewhere_url { "/attachments" }
        assert_equal "/attachments", send(:regular, location_url: @location_url)
      end
    end

    context "with resource" do
      test "with resource" do
        resource = stub
        mock(self).somewhere_url(resource) { "/attachments/42" }

        assert_equal "/attachments/42", send(:regular, location_url: @location_url, resource: resource)
      end
    end
  end

  describe "#location_url" do # rubocop:disable Metrics/BlockLength
    context "without resource" do
      test "should return root attachments url" do
        assert_equal "attachments_url", send(:location_url, resource_name: "attachments")
      end

      test "should return nested attachments url" do
        behaveable = stub
        stub(self).behaveable_name_from(behaveable) { "user" }

        assert_equal "user_attachments_url", send(:location_url, resource_name: "attachments", behaveable: behaveable)
      end

      test "should raise an error as edit route need a resource" do
        assert_raises(AttachmentsHelper::RouteHelperError) do
          send(:location_url, resource_name: "attachments", action: "edit")
        end
      end

      test "should raise an error as new route need a resource unpersisted" do
        resource = stub
        mock(resource).id { 42 } # persited resource

        assert_raises(AttachmentsHelper::RouteHelperError) do
          send(:location_url, resource_name: "attachments", action: "new", resource: resource)
        end
      end

      test "should raise an error as new route need a resource" do
        assert_raises(AttachmentsHelper::RouteHelperError) do
          send(:location_url, resource_name: "attachments", action: "new")
        end
      end
    end

    context "with resource" do # rubocop:disable Metrics/BlockLength
      test "should return root attachment url" do
        resource = stub

        assert_equal "attachment_url", send(:location_url, resource_name: "attachments", resource: resource)
      end

      test "should return root edit attachment url" do
        resource = stub

        assert_equal "edit_attachment_url",
                     send(:location_url, resource_name: "attachments", resource: resource, action: "edit")
      end

      test "should return root new attachment url" do
        resource = stub
        mock(resource).id { nil }

        assert_equal "new_attachment_url",
                     send(:location_url, resource_name: "attachments", resource: resource, action: "new")
      end

      test "should return nested attachment url" do
        behaveable = build(:user)
        resource = stub

        assert_equal "user_attachment_url",
                     send(:location_url, resource_name: "attachments", behaveable: behaveable, resource: resource)
      end

      test "should return nested edit attachment url" do
        behaveable = build(:user)
        resource = stub

        assert_equal "edit_user_attachment_url",
                     send(:location_url, resource_name: "attachments", behaveable: behaveable, resource: resource,
                                         action: "edit")
      end

      test "should return nested new attachment url" do
        behaveable = build(:user)
        resource = stub
        mock(resource).id { nil }

        assert_equal "new_user_attachment_url",
                     send(:location_url, resource_name: "attachments", behaveable: behaveable, resource: resource,
                                         action: "new")
      end
    end
  end

  describe "#resource_name_inflection" do
    context "singular" do
      test "should return singular name" do
        resource = stub
        assert_equal "attachment", send(:resource_name_inflection, resource_name: "attachments", resource: resource)
      end
    end

    context "plural" do
      test "should return plural name" do
        resource = nil
        assert_equal "attachments", send(:resource_name_inflection, resource_name: "attachments", resource: resource)
      end
    end
  end

  test "#behaveable_name_from" do
    behaveable = build(:user)
    assert_equal "user", send(:behaveable_name_from, behaveable)
    assert_nil send(:behaveable_name_from, nil)
  end
end
