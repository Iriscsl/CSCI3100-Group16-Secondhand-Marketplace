class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :user_community, class_name: "Community", foreign_key: "community", optional: true
  has_many :items, foreign_key: "seller_id"
  before_validation :strip_email_spaces
  validate :cuhk_email_format
  private

  def name_required?
    false
  end

  def strip_email_spaces
    self.email = email.to_s.strip if email.present?
  end

   def cuhk_email_format
    unless email =~ /@link\.cuhk\.edu\.hk$/
      errors.add(:email, "must be a CUHK email address (1155xxxxxx@link.cuhk.edu.hk)")
    end
  end

end
