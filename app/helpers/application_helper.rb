module ApplicationHelper
  def root_css_class_name
    %Q|#{controller_path.gsub("/", "_")}_controller #{action_name}_action|
  end
end
