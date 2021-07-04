# frozen_string_literal: true

require "test_helper"

class RouteExtractorTest < ActiveSupport::TestCase # rubocop:disable Metrics/ClassLength
  RouteExtractorKlass = Class.new do
    include Behaveable::RouteExtractor
  end

  setup do
    @instance = RouteExtractorKlass.new
  end

  describe "#location_url" do # rubocop:disable Metrics/BlockLength
    context "resources" do
      setup do
        @params = ActionController::Parameters.new({ controller: "attachment" })
      end

      test "should return root attachments url" do
        stub(@instance).params { @params }
        behaveable = nil

        assert_equal "attachments_url", @instance.send(:location_url, behaveable: behaveable)
      end

      test "should return nested attachments url" do
        stub(@instance).params { @params }
        behaveable = stub
        stub(@instance).behaveable_name_from(behaveable) { "user" }

        assert_equal "user_attachments_url", @instance.send(:location_url, behaveable: behaveable)
      end
    end

    context "resource" do
      setup do
        @params = ActionController::Parameters.new({ controller: "attachment", id: 42 })
      end

      test "should return root attachment url" do
        stub(@instance).params { @params }
        behaveable = nil
        resource = stub

        assert_equal "attachment_url", @instance.send(:location_url, behaveable: behaveable, resource: resource)
      end

      test "should return nested attachment url" do
        stub(@instance).params { @params }
        behaveable = stub
        stub(@instance).behaveable_name_from(behaveable) { "user" }

        assert_equal "user_attachments_url", @instance.send(:location_url, behaveable: behaveable)
      end
    end
  end

  describe "#regular" do # rubocop:disable Metrics/BlockLength
    setup do
      @location_url = "somewhere_url"
    end

    context "without resource" do
      test "should execute route helper attachments_url" do
        resource = nil
        mock(@instance).somewhere_url { "/attachments" }

        assert_equal "/attachments", @instance.send(:regular, location_url: @location_url, resource: resource)

        behaveable = nil
        params = ActionController::Parameters.new({ controller: "attachment" })
        stub(@instance).params { params }
        mock(@instance).regular(location_url: "attachments_url", resource: resource) { "/attachments" }

        assert_equal "/attachments", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end

    context "with resource" do
      test "with resource" do
        resource = stub
        mock(resource).id { 42 }
        mock(@instance).somewhere_url(resource) { "/attachments/42" }

        assert_equal "/attachments/42", @instance.send(:regular, location_url: @location_url, resource: resource)

        behaveable = nil
        params = ActionController::Parameters.new({ controller: "attachment", id: 42 })
        stub(@instance).params { params }
        mock(@instance).regular(location_url: "attachment_url", resource: resource) { "/attachments/42" }

        assert_equal "/attachments/42", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end
  end

  describe "#resource_name_from" do
    context "singular" do
      setup do
        @params = ActionController::Parameters.new({ controller: "attachment", id: 1 })
      end

      test "should return singular name" do
        stub(@instance).params { @params }
        resource = stub
        assert_equal "attachment", @instance.send(:resource_name_from, resource)
      end
    end

    context "plural" do
      setup do
        @params = ActionController::Parameters.new({ controller: "attachment" })
      end

      test "should return plural name" do
        stub(@instance).params { @params }
        resource = nil
        assert_equal "attachments", @instance.send(:resource_name_from, resource)
      end
    end
  end

  test "#behaveable_name_from" do
    behaveable = build(:attachment)
    assert_equal "attachment", RouteExtractorKlass.new.send(:behaveable_name_from, behaveable)
    assert_nil RouteExtractorKlass.new.send(:behaveable_name_from, nil)
  end

  describe "#nested" do # rubocop:disable Metrics/BlockLength
    setup do
      @location_url = "nested_somewhere_url"
    end

    context "without resource" do
      test "should execute route helper attachments_url" do
        resource = nil
        behaveable = User.new
        mock(@instance).nested_somewhere_url(behaveable) { "/users/24/attachments" }

        assert_equal "/users/24/attachments",
                     @instance.send(:nested, location_url: @location_url, behaveable: behaveable, resource: resource)

        params = ActionController::Parameters.new({ controller: "attachment" })
        stub(@instance).params { params }
        mock(@instance).nested(location_url: "user_attachments_url", behaveable: behaveable, resource: resource) do
          "/users/24/attachments"
        end

        assert_equal "/users/24/attachments", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end

    context "with resource" do
      test "with resource" do
        resource = stub
        mock(resource).id { 42 }
        behaveable = User.new
        mock(@instance).nested_somewhere_url(behaveable, resource) { "/users/24/attachments/42" }

        assert_equal "/users/24/attachments/42",
                     @instance.send(:nested, location_url: @location_url, behaveable: behaveable, resource: resource)

        params = ActionController::Parameters.new({ controller: "attachment", id: 42 })
        stub(@instance).params { params }
        mock(@instance).nested(location_url: "user_attachment_url", behaveable: behaveable, resource: resource) do
          "/users/24/attachments/42"
        end

        assert_equal "/users/24/attachments/42", @instance.extract(behaveable: behaveable, resource: resource)
      end
    end
  end
end
