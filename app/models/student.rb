class Student < ApplicationRecord
  belongs_to :site, optional: true
  has_many :comments, as: :resource
  acts_as_taggable_on :skills, :job_preferences, :tags
  validates_presence_of :first_name, :last_name

  def age
    dob = self.dob
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def name
    self.first_name + ' ' + self.last_name
  end

  def on_tag?
    if self.hdc&.past? && self.crd&.future?
      true
    else
      false
    end
  end

  def released?
    if self.crd&.past?
      true
    else
      false
    end
  end

  def out?
    if self.on_tag? || self.released?
      true
    else
      false
    end
  end

  def contactable?
    if self.out? || self&.site&.hub?
      true
    else
      false
    end
  end

end
