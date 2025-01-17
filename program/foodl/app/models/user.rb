# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :id
  has_secure_password

  before_save { |user| user.email = email.downcase}
  before_save :create_remember_token

  validates :name, length: { maximum: 50 } #, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_and_belongs_to_many :favorites, :join_table => 'users_recipes', :class_name => "Recipe"

  has_many :list_items
  has_many :issues

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
