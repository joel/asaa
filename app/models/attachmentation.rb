# frozen_string_literal: true

class Imageation < ApplicationRecord
  belongs_to :attachment
  belongs_to :imageable, polymorphic: true
end
