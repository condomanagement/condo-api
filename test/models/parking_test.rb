# frozen_string_literal: true

require "test_helper"

class ParkingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "to_csv" do
    first = Parking.new(
      "id": 1,
      "unit": 12,
      "code": "12345",
      "make": "NOCAR",
      "color": "green",
      "license": "ABC 123",
      "contact": "test@test.com",
      "created_at": Time.local(2020, 1, 1),
      "start_date": Time.local(2020, 1, 2),
      "end_date": Time.local(2020, 1, 3)
    )

    @parks = [first]

    the_csv = @parks.to_csv
    Parking.all.to_csv
    assert_equal the_csv.encoding, Encoding::ASCII
  end
end
