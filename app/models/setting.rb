# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  kind       :integer
#  value      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < ApplicationRecord
  validates :name, uniqueness: true

  SETTING_KIND = {
      string: 0,
      integer: 1,
      float: 2,
      bool: 3
  }

  SETTING_KIND_REVERSE = {
      0 => 'string',
      1 => 'integer',
      2 => 'float',
      3 => 'bool'
  }

  class << self
    def method_missing(method, *args)
      super(method, *args)
    rescue NoMethodError
      self[method.to_s]
    end

    def [](setting)
      a = self.find_by_name setting
      return a.value if a
      nil
    end

    def []=(setting, value)
      a = self.find_by_name setting
      if a
        a.update(value: value)
      else
        self.create!(name: setting, value: value)
      end
      value
    end

  end

end
