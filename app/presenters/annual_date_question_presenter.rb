class AnnualDateQuestionPresenter < QuestionPresenter
  def response_label(value)
    I18n.localize(Date.parse("#{Date.today.year}-#{value}"), format: :day_month_long)
  end

  def start_date
    @node.range == false ? 1.year.ago : @node.range.begin
  end

  def end_date
    @node.range == false ? 3.years.from_now : @node.range.end
  end
end
