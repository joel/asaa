# frozen_string_literal: true

class Attachment < ApplicationRecord
  has_many :extensions, dependent: :destroy

  has_one_attached :attachment, dependent: :destroy
end
