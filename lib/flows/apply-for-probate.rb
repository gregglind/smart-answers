status :draft
satisfies_need "131"


## Q1
multiple_choice :use_a_solicitor? do
  option :solicitor => :use_a_solicitor_outcome
  option :myself => :where_did_deceased_live?
end

## Q2
multiple_choice :where_did_deceased_live? do
  option :england_or_wales 
  option :scotland
  option :northern_ireland

  save_input_as :where_lived

  next_node :inheritance_tax?
end

## Q3 
multiple_choice :inheritance_tax? do
  option :yes
  option :no

  calculate :inheritance_tax do
    responses.last == "yes"
  end

  next_node do
    if where_lived == "northern_ireland"
      :which_ni_county?
    else 
      :amount_left_en_sco?
    end
  end
end

## Q4
multiple_choice :amount_left_en_sco? do
  option :under_five_thousand
  option :five_thousand_or_more

  calculate :fee_section do
    if responses.last == "under_five_thousand"
      PhraseList.new(:no_fee)
    else
      PhraseList.new(:fee_info_eng_sco)
    end
  end

  next_node do
    if where_lived == "england_or_wales"
      :done_eng_wales
    else
      if where_lived == "scotland"
        :done_scotland
      else
        :done_ni
      end
    end
  end
end

## Q5
multiple_choice :which_ni_county? do
  option :fermanagh_londonderry_tyrone
  option :antrim_armagh_down

  calculate :where_to_apply do
    if responses.last == "fermanagh_londonderry_tyrone"
      PhraseList.new(:apply_in_fermanagh_londonderry_tyrone)
    else
      PhraseList.new(:apply_in_antrim_armagh_down)
    end
  end

  next_node :amount_left_ni?
end

## Q6
multiple_choice :amount_left_ni? do
  option :under_ten_thousand
  option :ten_thousand_or_more

  calculate :fee_section do
    if responses.last == "under_ten_thousand"
      PhraseList.new(:no_fee)
    else
      PhraseList.new(:fee_info_ni)
    end
  end

  next_node :done_ni
end


outcome :no_will_outcome
outcome :no_executor_outcome
outcome :executor_not_willing_outcome
outcome :use_a_solicitor_outcome

outcome :done_eng_wales do
  precalculate :application_info do
    if inheritance_tax
      PhraseList.new(:eng_wales_inheritance_tax)
    else
      PhraseList.new(:eng_wales_no_inheritance_tax)
    end
  end

  precalculate :next_steps_info do
    if inheritance_tax
      PhraseList.new(:eng_wales_inheritance_tax_next_steps)
    else
      PhraseList.new(:eng_wales_no_inheritance_tax_next_steps)
    end
  end
end

outcome :done_scotland do
  precalculate :application_info do
    if inheritance_tax
      PhraseList.new(:scotland_inheritance_tax)
    else
      PhraseList.new(:scotland_no_inheritance_tax)
    end
  end

   precalculate :next_steps_info do
    if inheritance_tax
      PhraseList.new(:scotland_inheritance_tax_next_steps)
    else
      PhraseList.new(:scotland_no_inheritance_tax_next_steps)
    end
  end
end

outcome :done_ni do
  precalculate :application_info do
    if inheritance_tax
      PhraseList.new(:ni_inheritance_tax)
    else
      PhraseList.new(:ni_no_inheritance_tax)
    end
  end

  precalculate :application_info_part2 do
    if inheritance_tax
      PhraseList.new(:ni_inheritance_tax_part2)
    else
      PhraseList.new(:ni_no_inheritance_tax_part2)
    end
  end
end