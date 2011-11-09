module ApplicationHelper
  def language_link(language_string, localization_string)
    link_to image_tag("flags/"+localization_string+".png", :alt => language_string, :class => "flags"), request.env['REQUEST_URI'].gsub(/\/(en|de)\//n, "/" + localization_string + "/")
  end
  
  def logo
    image_tag("banner_2.jpg", :alt => "KHSuite", :class => "round")
  end
  
  def title
    base_title = "KHSuite"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
