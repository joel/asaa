# frozen_string_literal: true

json.array! @images, partial: "images/attachment", as: :attachment
