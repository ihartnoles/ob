json.array!(@housing_zipcodes) do |housing_zipcode|
  json.extract! housing_zipcode, :id, :zip, :city, :state, :county, :campus, :distance
  json.url housing_zipcode_url(housing_zipcode, format: :json)
end
