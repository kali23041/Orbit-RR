module ApplicationHelper
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
      "pending_payment" => "bg-amber-100 text-amber-900",
      "confirmed" => "bg-emerald-100 text-emerald-900",
      "completed" => "bg-slate-200 text-slate-800",
      "cancelled" => "bg-rose-100 text-rose-900",
      "refunded" => "bg-slate-100 text-slate-600"
    }
    content_tag(:span, status.humanize, class: "inline-flex rounded-sm px-2 py-0.5 text-xs font-medium #{tones.fetch(status, 'bg-slate-100')}")
  end
end
