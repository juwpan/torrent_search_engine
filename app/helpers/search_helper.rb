module SearchHelper
  def color_link_seed(seed)
    if seed.to_i > 0
      content_tag :span, seed, class: "text-success"
    else
      content_tag :span, seed, class: "text-danger"
    end
  end

  def color_link_lychee(lychee)
    if lychee.to_i > 0
      content_tag :span, lychee, class: "text-primary"
    else
      content_tag :span, lychee, class: "text-danger"
    end
  end
end
