class Conversation < ApplicationRecord 
  belongs_to :item
  belongs_to :buyer,  class_name: "User"
  belongs_to :seller, class_name: "User"
  has_many   :messages, dependent: :destroy 

  validate :seller_must_match_item_owner 

  private 

  def seller_must_match_item_owner
    return if item.blank? || seller.blank? 
    return if item.user == seller 
    
    errors.add(:seller, "must be the owner of the item") 
  end
end
