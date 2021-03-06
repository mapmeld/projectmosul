# Artefact, base level model for movable heritage
class Artefact < ActiveRecord::Base
  has_many :images, dependent: :destroy
  has_many :sketchfabs, dependent: :destroy

  after_initialize :set_uuid_value
  has_paper_trail

  scope :sketchfabless, lambda {
    where('id NOT IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }
  scope :with_sketchfabs, lambda {
    where('id IN (SELECT DISTINCT(artefact_id) FROM sketchfabs)')
  }

  self.per_page = 16

  def attachments_array=(array)
    array.each do |file|
      attachments.build(image: file)
    end
  end

  def set_uuid_value
    self.uuid ||= SecureRandom.uuid
  end
end
