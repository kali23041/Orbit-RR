module ApplicationHelper
  PORTFOLIO_URL = "https://kartiksabale.com".freeze
  DEVELOPER_NAME = "Kartik Sabale".freeze

  def format_money(cents, currency = "usd")
    amount = cents.to_i / 100.0
    unit = currency.to_s.upcase == "USD" ? "$" : "#{currency.to_s.upcase} "
    "#{unit}#{format('%.2f', amount)}"
  end

  def firebase_configured?
    Rails.application.config.x.firebase.project_id.present? &&
      Rails.application.config.x.firebase.client_config[:apiKey].present?
  end

  def booking_status_badge(status)
    tones = {
      "pending_payment" => "bg-amber-50 text-amber-800 border-amber-200",
      "confirmed" => "bg-accent-soft text-accent border-teal-200",
      "completed" => "bg-slate-100 text-ink border-line",
      "cancelled" => "bg-rose-50 text-rose-800 border-rose-200",
      "refunded" => "bg-slate-50 text-muted border-line"
    }
    content_tag(
      :span,
      status.humanize,
      class: "inline-flex rounded-sm border px-2 py-0.5 text-xs font-medium #{tones.fetch(status, 'bg-slate-50 text-muted border-line')}"
    )
  end

  def user_initials(user)
    return "?" unless user

    parts = user.display_name.to_s.split(/\s+/).first(2)
    parts.map { |part| part[0] }.join.upcase
  end

  def avatar_chip_for(user, size_class: "avatar-chip")
    return content_tag(:span, "?", class: size_class) unless user

    if user.avatar_url.present?
      content_tag(:span, class: size_class) do
        image_tag(user.avatar_url, alt: user.display_name)
      end
    else
      content_tag(:span, user_initials(user), class: size_class)
    end
  end

  def portfolio_link(text = DEVELOPER_NAME, **options)
    link_to text, PORTFOLIO_URL, { target: "_blank", rel: "noopener noreferrer" }.merge(options)
  end
end
