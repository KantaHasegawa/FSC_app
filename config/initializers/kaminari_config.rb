# frozen_string_literal: true

Kaminari.configure do |config|
  config.page_method_name = :kaminari_page
  config.default_per_page = 15
end
