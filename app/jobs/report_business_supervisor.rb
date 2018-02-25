class ReportBusinessSupervisor < ApplicationJob

  queue_as :default

  def perform(code_partner)

    report = []
    report << "-----------------------------------------"
    report << "Report BUSINESS SUPERVISOR"
    report << "-----------------------------------------"
    report << "Partner code : #{code_partner}"

    @partner = Partner.where(code_partner: code_partner).first
    unless @partner
      report << "ERROR : Partner code not found"
      edit_report(report)
    end
    unless @partner.try(:supervisor_id)
      report << "ERROR : Partner code not supervised"
      edit_report(report)
    end

    @supervisor = @partner.supervisor
    unless @supervisor
      report << "ERROR : Supervisor not found"
      edit_report(report)
    end
    report << "Supervisor : #{@supervisor.name}"
    report << "-----------------------------------------"

    report << "Nb actif users : #{User.where(code_partner: code_partner).where('date_end_partner < ?', Time.now).count}"
    report << "-----------------------------------------"

    votes = UserHistory.where(code_partner: code_partner).group(:cause_id).distinct.count(:user_id)
    votes.each do |vote|
      report << "#{Cause.find(vote[1]).name} : #{vote[1]}"
    end

    edit_report(report)

  end

  private

  def edit_report(report)

    # Report : Edit + Send to slack
    fields = []
    report.each do |line|
      puts line
      fields << { "value": line }
    end

    if Rails.env.production?
      notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_JOB_URL']
      attachment = {
        fallback: "Report BUSINESS SUPERVISOR",
        fields: fields,
        color: "good"
      }
      notifier.ping "Report BUSINESS SUPERVISOR", attachments: [attachment]
    end
    exit
  end
end
