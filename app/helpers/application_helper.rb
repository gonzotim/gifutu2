module ApplicationHelper

  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def display_nav_link(tag)
    # puts params[:action]
    # puts params[:tag]

    label = tag.downcase
    if params[:action] == "index" && params[:tag]  == tag
      html = <<-HTML
        <li class="active"><a href="/tags/#{label}">#{tag}</a></li>
      HTML

    else
      html = <<-HTML
        <li ><a href="/tags/#{label}">#{tag}</a></li>
      HTML
        

    end


    html.html_safe
  end

end

