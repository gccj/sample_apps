class CreateRelationshipNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :relationship_notifications do |t|
      t.integer :source_id, null: false, comment: '通知ユーザーID'
      t.integer :destination_id, null: false, comment: '被通知ユーザーID'
      t.boolean :readed, default: false, null: false, comment: '通知の閲覧状況'

      t.timestamps null: false
    end

    add_index :relationship_notifications, :destination_id
    add_index :relationship_notifications, [:source_id, :destination_id], unique: true, name: 'index_relationship_notifications_on_src_id_and_dst_id'
  end
end
