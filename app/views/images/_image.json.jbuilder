# frozen_string_literal: true

json.extract! attachment, :id, :name, :created_at, :updated_at
json.url image_url(attachment, format: :json)
