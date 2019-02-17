class AdminMailer < ApplicationMailer
  ADMIN_EMAIL = "mason@kissr.co"
  default from: 'notifications@kissr.com'

  def site_created_email(site)
    @site = site
    mail(to: ADMIN_EMAIL, subject: "New site created on kissr: http://#{@site.domain}/")
  end
end
