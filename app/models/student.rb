class Student < ApplicationRecord
  belongs_to :site, optional: true
  acts_as_taggable_on :skills, :job_preferences, :tags

  def age
    dob = self.dob
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end

  def name
    self.first_name + ' ' + self.last_name
  end

  def released?
    if self.crd.past?
      true
    else
      false
    end
  end
end
