# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    name { FFaker::Movie.title }
  end
end
