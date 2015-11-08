json.array!(@modules_availables) do |modules_available|
  json.extract! modules_available, :id, :znumber, :netid, :welcome, :deposit, :account, :communication, :immunization, :finaid, :housingfee, :residency, :housingmealplan, :aleks, :oars, :learning_comm, :orientation, :registration, :emergency, :faualert, :owlcard, :bookadvance, :tution, :vehiclereg
  json.url modules_available_url(modules_available, format: :json)
end
