class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { admin: 0, salesperson: 1, engineer: 2 }, validate: true
  enum :status, { inactive: 0, active: 1 }, validate: true

  has_many :projects, foreign_key: 'responsible_id', dependent: :nullify
  has_many :quotations, foreign_key: 'salesperson_id', dependent: :nullify

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }
  validates :username, length: { minimum: 3, maximum: 20 }

  scope :admin, -> { where(role: :admin) }

  # Virtual attribute for authentication
  attr_writer :login

  # Allow authentication by email or username
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(
        ["lower(email) = :value OR lower(username) = :value", { value: login.downcase }]
      ).first
    elsif conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def login
    @login || self.username || self.email
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null, uniquely indexed
#  encrypted_password     :string           default(""), not null
#  last_name              :string
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           uniquely indexed
#  role                   :integer          default("salesperson")
#  status                 :integer          default("active")
#  username               :string           uniquely indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
