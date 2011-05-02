Paperclip.interpolates('username') do |attachment, style|
  attachment.instance.username.parameterize
end

Paperclip.interpolates('folder_id') do |attachment, style|
  attachment.instance.get_folder_id.parameterize
end