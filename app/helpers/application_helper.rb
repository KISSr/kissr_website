module ApplicationHelper
  def bootsrap_flash_class(type)
    {
      "notice": "alert-success",
      "error": "alert-danger"
    }[type]
  end
end
