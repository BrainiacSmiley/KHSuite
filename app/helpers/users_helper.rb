# encoding: utf-8
module UsersHelper
  def doctors_badge_html(doctor)
    html_code = '<div class="doctorsbadge">'
    html_code += '  <div class="doctorsserver">'
    html_code += "   <strong>S#{doctor.server}</strong>"
    html_code += '  </div>'
    html_code += '  <div class="doctorsname">'
    html_code += "   <strong>#{doctor.name}</strong>"
    html_code += '  </div>'
    html_code += '  <div class="doctorsavatar">'
    html_code += "   #{image_tag doctor.avatar}"
    html_code += '  </div>'
    html_code += '  <div class="doctorsvalues">'
    html_code += "   ÄV: #{doctor.av}<br />"
    html_code += "   Level: #{doctor.level}<br />"
    html_code += "   Bargeld: #{doctor.level} hT<br />"
    html_code += "   Punkte: #{doctor.level}<br />"
    html_code += '  </div>'
    html_code += '  <br />'
    html_code += '  <div class="doctorstimestamp">'
    html_code += "   #{t(:doctor_creation, :ago => time_ago_in_words(doctor.created_at))}"
    html_code += '  </div>'
    html_code += '</div>'
  end
end
