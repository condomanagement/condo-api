# frozen_string_literal: true

class Reservation < ApplicationRecord
  default_scope { order(start_time: :desc) }
  belongs_to :user
  belongs_to :resource

  def self.today
    where(
      "start_time <= ? AND end_time >= ?",
      Time.now.in_time_zone("Eastern Time (US & Canada)").to_date,
      Time.now.in_time_zone("Eastern Time (US & Canada)").to_date
    )
  end

  def self.future
    where("start_time > ?", Time.now.in_time_zone("Eastern Time (US & Canada)").to_date).order("start_time ASC")
  end

  def self.past
    where(
      "end_time <= ?",
      Time.now.in_time_zone("Eastern Time (US & Canada)").to_date
    ).order("start_time desc")
  end
end
