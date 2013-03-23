class CreateS3Files < ActiveRecord::Migration
  def change
    create_table :s3_files do |t|
      t.string :s3_key
      t.string :name
      t.integer :size
      t.string :content_type
      t.datetime :uploaded_at
      t.boolean :uploaded

      t.timestamps
    end
  end
end
