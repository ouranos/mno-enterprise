class MandrillUtils
  def self.migrate_templates(src_api_key, dst_api_key)
    input = Mandrill::API.new(src_api_key)
    output = Mandrill::API.new(dst_api_key)

    templates = input.templates.list

    templates.each do |t|
      output.templates.add t['name'], t['from_email'],  t['from_name'], t['subject'], t['code'], t['text'], false, t['labels']
    end
    return true
  end
end

# MandrillUtils.migrate_templates('QcrLVdukhBi7iYrTeWHRPQ', MnoEnterprise.mandrill_key)
