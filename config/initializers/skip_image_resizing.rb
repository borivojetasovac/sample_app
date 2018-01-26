# Configure CarrierWave to skip image resizing in tests (to avoid possible confusing error messages)
if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end
