# frozen_string_literal: true

class Extension < ActiveRecord::Migration[5.2]
  def change
    create_table :extensions do |t|
      t.belongs_to :attachment, index: true
      t.references :attachable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
