# frozen_string_literal: true

class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :name

      t.timestamps
    end
  end
end
