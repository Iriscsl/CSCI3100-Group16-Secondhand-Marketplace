class Item < ApplicationRecord
  belongs_to :user
  include PgSearch::Model
  enum :status, [ :available, :reserved, :sold ]

  validates :price, numericality: { greater_than_or_equal_to: 4, message: "must be at least $4 HKD (Stripe minimum)" }

  enum :community, {
    chung_chi: 0,
    united: 1,
    new_asia: 2,
    shaw: 3,
    morningside: 4,
    shho: 5,
    cw_chu: 6,
    wu_yee_sun: 7,
    lee_woo_sing: 8
  }

  COMMUNITY_NAMES = {
    chung_chi: "Chung Chi College",
    united: "United College",
    new_asia: "New Asia College",
    shaw: "Shaw College",
    morningside: "Morningside College",
    shho: "S.H. Ho College",
    cw_chu: "C.W. Chu College",
    wu_yee_sun: "Wu Yee Sun College",
    lee_woo_sing: "Lee Woo Sing College"
  }.freeze

  def community_name
    return "Not specified" if community.nil?
    COMMUNITY_NAMES[community.to_sym]
  end

  # def community_name
  #   return "Not specified" if community.nil?
  #   symbol = Item.communities.key(community)   # integer -> symbol, e.g., 2 -> :new_asia
  #   Item::COMMUNITY_NAMES[symbol]              # symbol -> full name
  # end

  scope :with_statuses, ->(statuses) {
    return all if statuses.blank?
    where(status: statuses.map { |s| statuses_map[s] })
  }

  def self.statuses_map
    statuses
  end

  scope :min_price, ->(min) {
    return all if min.blank?
    where("price >= ?", min)
  }

  scope :max_price, ->(max) {
    return all if max.blank?
    where("price <= ?", max)
  }

  scope :with_community, ->(community) {
    return all if community.blank?
    where(community: communities[community])
  }

  pg_search_scope :search_items,
    against: [ :title, :description ],
    using: {
      trigram: {
        threshold: 0.2
      }
    }
end
