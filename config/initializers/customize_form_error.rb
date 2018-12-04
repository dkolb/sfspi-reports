# Shamelessly ripped off from
# https://jasoncharnes.com/bootstrap-4-rails-fields-with-errors
# ActionView::Base.field_error_proc = proc do |html_tag, _instance|
#   class_attr_index = html_tag.index 'class="'
#
#   if class_attr_index
#     html_tag.insert class_attr_index + 7, 'is-invalid '
#   else
#     html_tag.insert html_tag.index('>'), ' class="is-invalid"'
#   end
# end
#
# Adapted from https://rubyplus.com/articles/3401-Customize-Field-Error-in-Rails-5
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = ''

  form_fields = [
    'textarea',
    'input',
    'select'
  ]

  elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, " + form_fields.join(', ')

  if elements[0]['data-skiperror'] == "true"
    html = html_tag
  else
    elements.each do |e|
      if e.node_name.eql? 'label'
        html = %(#{e}).html_safe
      elsif form_fields.include? e.node_name
        e['class'] += ' is-invalid'
        if instance.error_message.kind_of?(Array)
          html = %(#{e}<div class="invalid-feedback">#{instance.error_message.uniq.join(', ')}</div>).html_safe
        else
          html = %(#{e}<div class="invalid-feedback">#{instance.error_message}</div>).html_safe
        end
      end
    end
  end
  html
end
