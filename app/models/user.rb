class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :user_community, class_name: 'Community', foreign_key: 'community', optional: true
  has_many :items, foreign_key: 'seller_id' 
  before_validation :strip_email_spaces
  private

  def name_required?
    false
  end

  def strip_email_spaces
    self.email = email.to_s.strip if email.present?
  end
end

