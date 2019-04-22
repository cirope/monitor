# frozen_string_literal: true

class ChangeTagsStyleDefaultToSecondary < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tags, :style, from: 'default', to: 'secondary'
  end
end
