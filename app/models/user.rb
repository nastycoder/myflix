class User < ActiveRecord::Base
  has_many :reviews, -> {order('created_at DESC')}
  has_many :queue_items, -> {order('position')}

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  # Turned secure password validations off to stop the complaining about password_confirmation
  has_secure_password validations: false

  def queued_video?(video)
    queue_items.map(&:video).include? video
  end

  def update_queue_items(batch)
    ActiveRecord::Base.transaction do
      begin
        batch.each do |key, values|
          queue_items.find(key).update!(values)
        end
        normalize_queue_order
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end

  def normalize_queue_order
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end
end
