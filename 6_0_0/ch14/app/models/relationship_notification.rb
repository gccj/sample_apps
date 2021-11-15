class RelationshipNotification < ApplicationRecord
  # Notification duck typing
  belongs_to :source, class_name: 'User', foreign_key: 'source_id'
  belongs_to :destination, class_name: 'User', foreign_key: 'destination_id'

  class << self
    def create_notification(source_id:, destination_id:)
      find_or_create_by(source_id: source_id, destination_id: destination_id)
    end

    def all_unread_notifications(destination_id:)
      # 通常ならば、paginationで、一回取得する件数を限定する
      where(destination_id: destination_id, readed: false)
        .order(created_at: :desc)
        .to_a
    end

    def recent_summary(destination_id:, duration: 60 * 5)
      # 通常ならば、paginationで、一回取得する件数を限定する
      notifications = eager_load(:source)
                        .where(destination_id: destination_id, readed: false, created_at: (Time.zone.now - duration)..Time.zone.now)
                        .order(created_at: :desc)
                        .to_a

      summary = nil
      if notifications.size > 1
        summary = "#{notifications.first.source.name}さんと他の#{notifications.size - 1}人があなたをフォローしました。"
      elsif notifications.size == 1
        summary = "#{notifications.first.source.name}さんがあなたをフォローしました。"
      end
      return summary
    end
  end

  def title
    # 通知のタイトル
  end

  def body
    # 通知の本文
  end

  def source_link
    # 通知の飛ばす先
  end

  def to_s
    # titleとbodyをそれぞれデザイン適用しない場合使える
    "#{title}--#{body}"
  end

  def make_as_read
    # 確認済みにする
    update(checked: true)
  end
end
