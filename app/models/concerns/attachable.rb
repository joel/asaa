# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern
  included do
    has_many :extensions, as: :attachable, dependent: :destroy
    has_many :attachments, through: :extensions, dependent: :destroy
  end
end
