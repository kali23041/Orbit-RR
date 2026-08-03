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
end
