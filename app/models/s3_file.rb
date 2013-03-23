class S3File < ActiveRecord::Base
  
  attr_accessible :content_type, :name, :size, as: :create
 
  validates :content_type, presence: true, on: :update
  validates :name, presence: true
  validates :size, presence: true
  validates :s3_key, presence: true


  scope :uploaded, ->{ where(uploaded: true) }

  before_validation on: :create do
    self.s3_key = 'tmp/%s_%s' % [SecureRandom.hex(3), name]
  end

  before_create do
    self.content_type = 'application/octetstream' if content_type.blank?
  end


  def uploaded!
    self.uploaded_at = Time.zone.now
    self.uploaded = true
    save!
  end

end
