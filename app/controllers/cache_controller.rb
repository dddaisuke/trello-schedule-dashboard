class CacheController < ApplicationController
  def clear
    Rails.cache.clear
    redirect_to dashboard_index_path, flash: { alert_message: 'Clear cache!' }
  end
end
