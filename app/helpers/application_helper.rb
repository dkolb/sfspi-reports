module ApplicationHelper
  def flash_class(level)
    case level
        when 'notice' then "alert alert-info"
        when 'success' then "alert alert-success"
        when 'error' then "alert alert-danger"
        when 'alert' then "alert alert-error"
        else "alert alert-info"
    end
  end

  def nav_link_to(text, path, active)
    active_link_to text,
      path,
      active: active,
      wrap_tag: :li,
      wrap_class: 'nav-item',
      class: 'nav-link'
  end

  def dropdown_nav(name, id, active_regex, links=[])
    nav_class = "nav-item dropdown"
    if active_regex.nil?
      is_active = false
    else
      is_active = is_active_link?(request.env['PATH_INFO'], active_regex)
    end
    nav_class << " active" if is_active

    render partial:  'layouts/nav_dropdown',
      locals: {
        name: name,
        id: id,
        links: links,
        nav_item_class: nav_class
      }
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def user_dropdown_links
    links = [ { name: 'Logout', path: logout_path, disable_turbo: true } ]
    if current_user.record_link
      links << {
        name: 'Profile',
        path: edit_member_path(current_user.record_link)
      }
    end

    links
  end

  def img_src_set(options = {})
    prefix = options.delete :prefix
    default_size = options.delete :default_size
    ext = options.delete :ext
    srcset = options.delete(:srcset) || []
    content = options.delete(:content) || ''

    options[:src] = asset_pack_path(
        "#{prefix}-#{default_size}.#{ext}"
    )

    srcset_value = []
    sizes_value = []

    srcset.each do |s|
      img_path = asset_pack_path(
        "#{prefix}-#{s[:size]}.#{ext}"
      )

      srcset_value << "#{img_path} #{s[:size]}"

      if s[:max_width]
        sizes_value << "(max-width: #{s[:max_width]}) #{s[:image_size]}"
      elsif s[:min_width]
        sizes_value << "(min-width: #{s[:min_width]}) #{s[:image_size]}"
      end
    end

    options[:srcset] = srcset_value.join(",")
    options[:sizes]  = sizes_value.join(",")

    tag.img content, options
  end

  def inline_remote_stylesheet(source)
    css = Net::HTTP.get(URI(source))
    tag.style(css)
  end

  def inline_remote_js(source)
    js = Net::HTTP.get(URI(source))
    tag.script(js)
  end

  def o365_link_list
    [
      {
        name: 'Outlook Email',
        target: '_blank',
        path: 'https://outlook.office.com'
      },
      {
        name: 'SharePoint',
        target: '_blank',
        path: 'https://sflsisters.sharepoint.com/SitePages/Home.aspx'
    },
    {
      name: 'My Files',
      target: '_blank',
      path: 'https://sflsisters-my.sharepoint.com/_layouts/15/MySite.aspx?' \
        'MySiteRedirect=AllDocuments'
    }
  ]
  end

  def gsuite_link_list
    [
      {
        name: 'GMail',
        target: '_blank',
        path: 'http://mail.southfloridasisters.org'
      },
      {
        name: 'Calendar',
        target: '_blank',
        path: 'http://calendar.southfloridasisters.org'
      },
      {
        name: 'Drive',
        target: '_blank',
        path: 'http://drive.southfloridasisters.org'
      }
    ]
  end

  def attendance_link_list
    links = [ { name: 'Active Members', path: attendance_summary_path } ]
    if is_secretary?
      links << { name: 'Specific Member', path: attendance_all_members_path }
    end
    links
  end
end
