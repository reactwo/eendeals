# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  mobile                 :string(255)
#  gender                 :integer
#  name                   :string(255)
#  refer_id               :string(255)
#  sponsor_id             :string(255)
#  real_sponsor_id        :string(255)
#  authentication_token   :string(30)
#  status                 :integer          default(0)
#  token                  :string(255)
#  hollow                 :boolean          default(FALSE)
#  lock                   :boolean          default(FALSE)
#  lock_last              :date
#  game                   :boolean          default(FALSE)
#  game_last              :date
#

class User < ApplicationRecord
  rolify
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable, :rememberable

  validates :mobile, :gender, :name, presence: true
  validates :mobile, :refer_id, uniqueness: true
  after_create :basic_setup

  has_one :wallet, dependent: :destroy
  has_many :transactions, dependent: :nullify
  has_many :limits, dependent: :destroy
  has_many :quiz_attempts
  has_many :user_refers
  has_many :down_users, class_name: 'UserRefer', foreign_key: :down_user_id
  has_many :quiz_winners
  has_many :task_submits
  has_many :redeems
  has_many :reward_tasks
  has_many :deal_uploads
  has_many :conversions
  belongs_to :sponsor, class_name: 'User', primary_key: :refer_id, required: false
  belongs_to :real_sponsor, class_name: 'User', primary_key: :refer_id, required: false

  GENDER = {
      male: 1,
      female: 2
  }

  GENDER_REVERSE = {
      1 => 'Male',
      2 => 'Female'
  }

  STATUS = {
      verified: 1,
      blocked: 2,
      approved: 3,
      lockscreen: 4
  }

  STATUS_REVERSE = {
      1 => 'Verified',
      2 => 'Blocked',
      3 => 'Verified',
      4 => 'Lock Screen'
  }

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.closing
    User.where(status: 3).in_batches(of: 20) do |users|
      ids = users.pluck(:id)
      Wallet.where('active >= ? AND user_id IN (?)', 10, ids).in_batches do |wallets|
        User.delay.give_rewards wallets
      end
    end
  end

  def self.give_rewards(wallets)
    wallets.each do |wallet|
      User.transaction do
        active_amount = wallet.active
        wallet.active = 0
        wallet.redeem = active_amount - 10
        wallet.save
        user = wallet.user

        # Give reward to direct sponsor
        real_sponsor = User.find_by_refer_id user.real_sponsor_id
        if real_sponsor
          real_sponsor_wallet = real_sponsor.wallet
          if real_sponsor_wallet
            if real_sponsor.status === STATUS[:approved]
              real_sponsor_wallet.redeem += 0.5
            else
              real_sponsor_wallet.passive += 0.5
            end
            Transaction.create(user: real_sponsor, amount: 0.5, category: Transaction::CATEGORY[:daily], direction: Transaction::DIRECTION[:credit], from_user: user)
            real_sponsor_wallet.save
          end

          # Give rewards to up-line
          sponsor = User.find_by_refer_id user.sponsor_id
          level = 0
          rewards = [0.8, 0.7, 0.6, 0.5, 0.4, 0.4, 0.3, 0.3, 0.3, 0.3]
          while sponsor != nil && level <= 9
            sponsor_wallet = sponsor.wallet
            if sponsor_wallet
              if sponsor.status === STATUS[:approved]
                sponsor_wallet.redeem += rewards[level]
              else
                sponsor_wallet.passive += rewards[level]
              end
              Transaction.create(user: sponsor, amount: rewards[level], category: Transaction::CATEGORY[:daily], direction: Transaction::DIRECTION[:credit], from_user: user)
              sponsor_wallet.save
            end

            sponsor = sponsor.sponsor

            level += 1
          end
        end
      end
    end
  end

  def self.check_apps
    User.where('DATE(`users`.`lock_last`) < DATE(?)', Date.today - 2.days).where(lock: true).update_all(lock: false)
    User.where('DATE(`users`.`game_last`) < DATE(?)', Date.today - 2.days).where(game: true).update_all(lock: false)
    User.delay(run_at: DateTime.now + 4.hours).check_apps
  end

  def hollow_under
    hollow_users = User.joins(:down_users).select('user_refers.down_user_id').where('users.hollow = ? AND user_refers.user_id = ?', 1, id)
    if hollow_users.count > 0
      hollow_users.first
    else
      nil
    end
  end

  def make_old_user
    old_user = OldUser.new
    old_user.email = email
    old_user.mobile = mobile
    old_user.name = name
    old_user.refer_id = refer_id
    old_user.sponsor_id = sponsor_id
    old_user.real_sponsor_id = real_sponsor_id
    old_user.status = status

    old_user.save

    old_user
  end

  private

  def basic_setup
    create_wallet(active: 0, passive: 0)
  end
end
