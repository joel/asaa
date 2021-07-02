# frozen_string_literal: true

class Extension < ApplicationRecord
  belongs_to :attachment
  belongs_to :attachable, polymorphic: true
end
