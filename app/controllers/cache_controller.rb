class CacheController < ApplicationController
  http_basic_authenticate_with name: ENV['TDD_NAME'], password: ENV['TDD_PASS']

  def clear
    Rails.cache.clear
    redirect_to dashboard_index_path, flash: { alert_message: 'Clear cache!' }
  end
end
