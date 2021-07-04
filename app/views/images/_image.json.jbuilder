# frozen_string_literal: true

json.extract! attachment, :id, :name, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
