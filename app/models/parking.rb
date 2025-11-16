# frozen_string_literal: true
# typed: strict

require "csv"

class DateValidator < ActiveModel::Validator
  extend T::Sig

  sig { params(record: T.untyped).void }
  def validate(record)
    return if record.end_date.nil? || record.start_date.nil?
    return multiple_months(record) if multiple_months?(record)

    month(record)
  end

  sig { params(record: T.untyped).returns(T.nilable(T::Boolean)) }
  def multiple_months?(record)
    true if record&.end_date&.month != record&.start_date&.month
  end

  sig { params(record: T.untyped).void }
  def month(record)
    record.errors.add :base, I18n.t("errors.too_long") if
      (record.end_date - record.start_date).to_i > ENV["NUMBER_OF_DAYS"].to_i
  end

  sig { params(record: T.untyped).void }
  def multiple_months(record)
    if (record.end_date.month - record.start_date.month > 1) ||
       current_month_too_long(record) || next_month_too_long(record)
      too_long(record)
    end
  end

  # rubocop:disable Naming/PredicateMethod
  sig { params(record: T.untyped).returns(T::Boolean) }
  def current_month_too_long(record)
    return true if Time.days_in_month(record.start_date.month, record.start_date.year) - record.start_date.day >
                   ENV["NUMBER_OF_DAYS"].to_i

    false
  end

  sig { params(record: T.untyped).returns(T::Boolean) }
  def next_month_too_long(record)
    return true if record.end_date.day > ENV["NUMBER_OF_DAYS"].to_i

    false
  end
  # rubocop:enable Naming/PredicateMethod

  sig { params(record: T.untyped).void }
  def too_long(record)
    record.errors.add :base, I18n.t("errors.too_long")
  end
end

class Parking < ApplicationRecord
  extend T::Sig

  validates :unit, presence: true, numericality: { only_integer: true }
  validates :make, presence: true
  validates :color, presence: true
  validates :license, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :contact, presence: true
  validates_with DateValidator

  scope :today, -> { where("start_date <= ? AND end_date >= ?", Time.zone.today, Time.zone.today) }
  scope :future, -> { where("start_date > ?", Time.zone.today) }
  scope :past, -> { where(end_date: ..Time.zone.today).order(start_date: :desc) }

  sig { returns(String) }
  def self.to_csv
    attributes = ["id", "unit", "code", "make", "color", "license", "contact", "created_at", "start_date", "end_date"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      find_each do |p|
        csv << attributes.map { |attr| p.send(attr) }
      end
    end
  end
end
